# stockdb-scraper2-devについて

## 概要

Proxmox3上のUbuntu 24.04 Server cloud-initテンプレート（VM ID `9100`）を完全クローンし、`stockdb-scraper2-dev` VMを作成するOpenTofu構成です。

- VM ID: `124`
- vCPU: `4`
- メモリ: `32768 MiB`（32 GiB）
- OSディスク: `60 GiB`
- 固定IPv4アドレス: `192.168.0.124/24`
- 初期ユーザー: `proxmox3/env.tfvars` の `vm_username`
- SSH認証: 公開鍵認証
- Proxmoxノード起動時の自動起動: 有効

## 前提条件

- Proxmox3にVM ID `9100`のUbuntu 24.04 cloud-initテンプレートが存在すること
- VM ID `124`とIPアドレス`192.168.0.124`が未使用であること
- Proxmoxストレージ`local-lvm`とブリッジ`vmbr0`が存在すること
- 以下のSSH公開鍵が存在すること
  - `/opt/automation/keys/id_homelab_ogs-digilife.pub`
  - `/opt/automation/keys/desktop-0i3anuu/ogs-digilife.pub`
  - `/opt/automation/keys/id_homelab_rundeck.pub`
- `TF_VAR_proxmox_api_token`にProxmox3用APIトークンが設定されていること

APIトークンは機密情報のため、`.tf`や追跡対象の`.tfvars`へ保存しません。

```bash
export TF_VAR_proxmox_api_token="<user>@<realm>!<token-id>=<secret>"
```

## SSH接続

`stockdb-scraper2-dev`へ管理者として接続する場合は、OpenTofuが登録した公開鍵に対応する秘密鍵を指定します。

| 項目 | 値 |
|---|---|
| 接続先 | `192.168.0.124` |
| 接続ユーザー | `ogs-digilife` |
| 秘密鍵 | `~/.ssh/id_homelab_ogs-digilife` |
| 対応する公開鍵 | `/opt/automation/keys/id_homelab_ogs-digilife.pub` |

```bash
ssh -i ~/.ssh/id_homelab_ogs-digilife \
  ogs-digilife@192.168.0.124
```

`ssh -i`には秘密鍵を指定します。`/opt/automation/keys/`にある`.pub`ファイルはVMへ登録するための公開鍵であり、SSH接続時のidentity fileとしては使用しません。

## 実行方法

このディレクトリで、Proxmox3共通値とVM固有値の両方を指定します。

```bash
cd /opt/automation/opentofu/homelab/proxmox3/stockdb-scraper2-dev
source ../../secrets/proxmox3.sh
tofu init
tofu fmt -check
tofu validate
tofu plan \
  -out=stockdb-scraper2-dev.tfplan \
  -var-file=../env.tfvars \
  -var-file=stockdb-scraper2-dev.tfvars
```

`source`でProxmox3用APIトークンの環境変数を現在のシェルへ読み込んでから、後続の`tofu`コマンドを実行します。

planで作成対象、VM ID、テンプレートID、ノード、ストレージ、ネットワークを確認してから、確認済みのplanファイルを適用します。

```bash
tofu apply stockdb-scraper2-dev.tfplan
```

planファイルは機密情報を含む可能性がある一時成果物のため、Gitへコミットしないでください。

stateはローカル管理です。`terraform.tfstate`にも機密情報が含まれ得るため、Gitへコミットしないでください。
