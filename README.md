# このリポジトリについて

## 概要

OpenTofu構成ファイルを管理するリポジトリ。

## ディレクトリ構成

### プロジェクトフォルダ構成

- プロジェクトフォルダの直下の階層は、構築環境単位とする。
- ここでは、プロジェクトルート(`opentofu`)でgitリポジトリを作成することとする。

```text
opentofu/
├── .gitignore
├── README.md
└── homelab/
```

### 環境単位のフォルダ構成

- 環境フォルダの直下の階層は、プロバイダ単位とする。  
- `secrets/`フォルダでは、環境固有であり、環境共通の機微データ(apiキーやログインパスワードなど)をopentofuホストの環境変数にセットするスクリプトファイルを管理する。
- プロバイダとは、仮想環境構築先の仮想化基盤のことで、同一のクレデンシャルで接続できる単位。

```text
opentofu/homelab
├── secrets/
├── proxmox2/
├── proxmox3/
```

secrets/の構成例

```text
opentofu/homelab/secrets/
└─ proxmox2.sh
```

`proxmox2.sh`の例。  
opentofu/homelab/secrets/proxmox2.sh


```bash
export TF_VAR_proxmox_api_token="proxmoxuser@pam!rundeck=xxxxx"
```

### プロバイダ単位のフォルダ構成

- プロバイダ単位の直下の階層は、ホスト(VM単位)とする
- `env.tfvars`は、プロバイダ共通のパラメータを定義する`opentofu`構成ファイルの１つ  
  プロバイダのapiエンドポイントなど。

```text
automation/opentofu/homelab/proxmox2/
├── env.tfvars
└── ubuntu2404-server-test01/
```

env.tfvarsの例

```bash
# env.tfvars
# Proxmox環境共通設定

proxmox_endpoint = "https://192.168.0.180:8006"

# 検証環境のため自己証明書を許容
proxmox_insecure = true

# proxmoxデータセンタ2で管理しているproxmoxのnode名
proxmox_node = "proxmox2"
```

### guest vm単位のフォルダ構成

プロバイダ単位のフォルダの配下に、各guest VM単位にフォルダを作成し、その中にguest VM用のOpenTofu構成ファイルを配置している。
以下は、guest vm単位のフォルダ内の構成ファイル配置例。

```text
homelab/
├── secrets/
│   ├── proxmox2.sh.sample
│   └── proxmox3.sh.sample
├── proxmox2/
│   ├── env.tfvars
│   └── ubuntu2404-server-test01/
│       ├── main.tf
│       ├── variables.tf
│       ├── ubuntu2404-server-test01.tfvars
│       ├── outputs.tf
│       ├── .terraform.lock.hcl
│       └── README.md
└── proxmox3/
    ├── env.tfvars
    └── deliver-dev/
        ├── main.tf
        ├── variables.tf
        ├── deliver-dev.tfvars
        ├── outputs.tf
        ├── .terraform.lock.hcl
        └── README.md
```

## 実行方法

対象VMのディレクトリで、接続先Proxmoxの共通値とVM固有値を指定する。以下は`deliver-dev`の例。

```bash
cd /opt/automation/opentofu/homelab/proxmox3/deliver-dev
source ../../secrets/proxmox3.sh
tofu init
tofu fmt -check
tofu validate
tofu plan \
  -out=deliver-dev.tfplan \
  -var-file=../env.tfvars \
  -var-file=deliver-dev.tfvars
```

planでVM ID、テンプレートID、ノード、ストレージ、ネットワークと、作成・変更・削除の対象を確認してから適用する。

```bash
tofu apply deliver-dev.tfplan
```

`tofu apply`や`tofu destroy`はProxmox上のリソースを変更するため、実行前に対象環境とplanを確認する。

## SSH鍵の管理と接続

OpenTofuで作成するguest VMには、cloud-initを通じてSSH公開鍵を登録する。
秘密鍵は接続元ホストの`~/.ssh/`など、利用者ごとの安全な場所に保管し、OpenTofuリポジトリや`/opt/automation/keys/`には配置しない。

この環境では、SSH鍵を次のように管理する。

| 用途                  | 秘密鍵の保管先                                               | OpenTofuが参照する公開鍵                                   |
| ------------------- | ----------------------------------------------------- | -------------------------------------------------- |
| 管理者からの接続            | `~/.ssh/id_homelab_ogs-digilife`                      | `/opt/automation/keys/id_homelab_ogs-digilife.pub` |
| RundeckからのAnsible実行 | Rundeckホストの`/var/lib/rundeck/.ssh/id_homelab_rundeck` | `/opt/automation/keys/id_homelab_rundeck.pub`      |

SSH接続時の`-i`には公開鍵ではなく、対応する秘密鍵を指定する。通常、SSH接続に`sudo`は必要ない。

```bash
ssh -i ~/.ssh/id_homelab_ogs-digilife <guest-user>@<guest-ip>
```

### 操作端末の公開鍵

Windows PCなど、管理者が普段SSH接続元として使用する操作端末では、端末ごとに異なるSSH鍵ペアを使用する。
秘密鍵は操作端末から持ち出さず、OpenTofuを実行するRundeckホストには公開鍵だけをコピーする。

Rundeckホスト上では、操作端末のホスト名ごとにディレクトリを分け、次の形式で公開鍵を配置する。

```text
/opt/automation/keys/<操作端末のホスト名>/homelab-admin.pub
```

例えば、操作端末のホスト名が`windows-pc01`の場合は、次の場所に配置する。

```text
/opt/automation/keys/windows-pc01/homelab-admin.pub
```

公開鍵のコメントにも`<利用者名>@<操作端末のホスト名>`を設定しておくと、VMの`authorized_keys`から所有者と端末を識別しやすい。

### 新しい操作端末を追加する手順

1. 新しい操作端末で、その端末専用のSSH鍵ペアを作成する。以下はGit Bashでの例。

   ```bash
   ssh-keygen -t ed25519 \
     -f "$HOME/.ssh/id_homelab" \
     -C "<利用者名>@<操作端末のホスト名>"
   ```

2. 秘密鍵は操作端末に保管したまま、公開鍵`id_homelab.pub`だけをRundeckホストへコピーする。

   ```text
   /opt/automation/keys/<操作端末のホスト名>/homelab-admin.pub
   ```

   Git Bashからコピーする場合は、先にRundeckホスト上へ操作端末用ディレクトリを作成し、`scp`で公開鍵を転送する。

   ```bash
   operation_host="$(hostname | tr '[:upper:]' '[:lower:]')"
   ssh "<Rundeck接続ユーザー>@<Rundeckホスト>" \
     "mkdir -p /opt/automation/keys/${operation_host}"
   scp "$HOME/.ssh/id_homelab.pub" \
     "<Rundeck接続ユーザー>@<Rundeckホスト>:/opt/automation/keys/${operation_host}/homelab-admin.pub"
   ```

   `<Rundeck接続ユーザー>`には`/opt/automation/keys/`への書き込み権限が必要である。

3. 対象guest VMの`main.tf`にあるcloud-initの`user_account.keys`へ、コピーした公開鍵を追加する。

   ```hcl
   user_account {
     username = var.vm_username
     keys = [
       file("/opt/automation/keys/<操作端末のホスト名>/homelab-admin.pub"),
       file("/opt/automation/keys/id_homelab_rundeck.pub")
     ]
   }
   ```

4. 対象guest VMのディレクトリでplanを作成し、公開鍵の追加以外に意図しない変更がないことを確認してから適用する。

   ```bash
   cd /opt/automation/opentofu/homelab/<provider>/<guest-vm-name>
   source ../../secrets/<provider>.sh
   tofu plan \
     -out=<guest-vm-name>.tfplan \
     -var-file=../env.tfvars \
     -var-file=<guest-vm-name>.tfvars
   tofu apply <guest-vm-name>.tfplan
   ```

このcloud-init設定は、新規作成または再作成されるguest VMの初期公開鍵を登録するためのものである。
すでに起動済みのguest VMでは、`tofu apply`でcloud-init設定を更新してもOS上の`authorized_keys`へ反映されない場合があるため、既存VMへの鍵の追加・削除はAnsibleで管理する。

新しいguest VMを追加する場合は、管理者用とRundeck用の公開鍵をOpenTofuのcloud-init設定へ登録し、VM固有のREADMEに接続ユーザー、IPアドレス、使用する秘密鍵、接続コマンドを記載する。

## OpenTofu実行計画の運用ルール

stateは各guest VMディレクトリでローカル管理する。

- `terraform.tfstate`とそのバックアップは機密情報を含む可能性があるため、Gitへコミットしない。
- `.terraform/`は`tofu init`で再生成できるため、Gitへコミットしない。
- `.terraform.lock.hcl`はproviderバージョンを再現するため、guest VM単位でGitへコミットする。

`tofu plan -out` で保存する実行計画は、`<対象名>.tfplan` の形式で命名する。
例えば、`deliver-dev` の実行計画は `deliver-dev.tfplan` とする。

```bash
tofu plan -out=<対象名>.tfplan [変数オプション]
tofu apply <対象名>.tfplan
```

planファイルは作成時点の構成やstateに依存し、機密情報を含む可能性がある。
そのため一時成果物として扱い、Gitへコミットしない。`.gitignore` で `*.tfplan` を除外している。
