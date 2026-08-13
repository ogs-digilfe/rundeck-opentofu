# VMテンプレート一覧

このファイルでは、`proxmox3`ノードでOpenTofuから利用するVMテンプレートを管理します。

## テンプレート

| Template ID | OS | ソースイメージ | cloud-init | qemu-guest-agent | 備考 |
|---:|---|---|---|---|---|
| `9100` | Ubuntu Server 24.04 LTS | `ubuntu-24.04-server-cloudimg-amd64.img` | 対応 | `true` | 初期設定なし（初期ユーザはパスワードなしで`sudo`が利用可能）<br>`python3`、`git`を同梱 |

## 利用時の確認事項

- `template_vm_id`には、この一覧のTemplate IDを指定します。
- `tofu plan`の前に、対象テンプレートが`proxmox3`ノードに存在することを確認します。
- テンプレートのOS、cloud-init、qemu-guest-agentの状態が、作成するVMの要件と一致していることを確認します。
- テンプレートを追加または更新した場合は、この一覧の情報も更新します。

## 参照元

- `deliver-dev/deliver-dev.tfvars`
- `deliver-dev/README.md`
