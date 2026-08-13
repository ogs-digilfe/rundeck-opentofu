# deliver-devについて

## 概要

Proxmox3上のUbuntu 24.04 Server cloud-initテンプレート（VM ID `9100`）を完全クローンし、`deliver-dev` VMを作成するOpenTofu構成です。

- VM ID: `156`
- 固定IPv4アドレス: `192.168.0.156/24`
- 初期ユーザー: `proxmox3/env.tfvars` の `vm_username`
- SSH認証: 公開鍵認証
- Proxmoxノード起動時の自動起動: 有効

## 前提条件

- Proxmox3にVM ID `9100`のUbuntu 24.04 cloud-initテンプレートが存在すること
- VM ID `156`とIPアドレス`192.168.0.156`が未使用であること
- Proxmoxストレージ`local-lvm`とブリッジ`vmbr0`が存在すること
- 以下のSSH公開鍵が存在すること
  - `/opt/automation/keys/id_homelab_ogs-digilife.pub`
  - `/opt/automation/keys/id_homelab_rundeck.pub`
- `TF_VAR_proxmox_api_token`にProxmox3用APIトークンが設定されていること

APIトークンは機密情報のため、`.tf`や追跡対象の`.tfvars`へ保存しません。

```bash
export TF_VAR_proxmox_api_token="<user>@<realm>!<token-id>=<secret>"
```

## SSH接続

`deliver-dev`へ管理者として接続する場合は、OpenTofuが登録した公開鍵に対応する秘密鍵を指定します。SSH接続に`sudo`は必要ありません。

| 項目 | 値 |
|---|---|
| 接続先 | `192.168.0.156` |
| 接続ユーザー | `ogs-digilife` |
| 秘密鍵 | `~/.ssh/id_homelab_ogs-digilife` |
| 対応する公開鍵 | `/opt/automation/keys/id_homelab_ogs-digilife.pub` |

```bash
ssh -i ~/.ssh/id_homelab_ogs-digilife \
  ogs-digilife@192.168.0.156
```

`ssh -i`には秘密鍵を指定します。`/opt/automation/keys/`にある`.pub`ファイルはVMへ登録するための公開鍵であり、SSH接続時のidentity fileとしては使用しません。

## 実行方法

このディレクトリで、Proxmox3共通値とVM固有値の両方を指定します。

```bash
cd /opt/automation/opentofu/homelab/proxmox3/deliver-dev
tofu init
tofu fmt -check
tofu validate
tofu plan \
  -out=deliver-dev.tfplan \
  -var-file=../env.tfvars \
  -var-file=deliver-dev.tfvars
```

planで作成対象、VM ID、テンプレートID、ノード、ストレージ、ネットワークを確認してから、確認済みのplanファイルを適用します。

```bash
tofu apply deliver-dev.tfplan
```

`tofu plan -out` の出力名は任意ですが、本リポジトリでは `<対象名>.tfplan` に統一します。
planファイルは機密情報を含む可能性がある一時成果物のため、Gitへコミットしないでください。

stateはローカル管理です。`terraform.tfstate`にも機密情報が含まれ得るため、Gitへコミットしないでください。
