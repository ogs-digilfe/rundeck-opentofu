# ubuntu2404-server-test01について

## 概要

ubuntu24.04 serverのcloudイメージでOSをインストールし、ここに`qemu-guest-agent`パッケージをインストールしただけの仮想マシンテンプレートから新規のguest VMを作成する`open tofu`の構成ファイル群。  
OSインストール後の初期設定も何も施しない。

## 主な作成時の構成情報

項目 | 内容 | 補足
-- | -- | --
OS | ubuntu24.04 server | Guiなし
ソースイメージ | ubuntu-24.04-server-cloudimg-amd64.img | この仮想マシンの作成元OSイメージ
インストールパッケージ | qemu-guest-agent | proxmoxのguest agent。<br>これがないと`proxmox`のAPIを介してguest vmを自動作成/設定ができない。
SSH認証方式 | 公開鍵認証のみ | 管理者用とRundeck用の公開鍵をcloud-initで登録する

## SSH接続

`ubuntu2404-server-test01`へ管理者として接続する場合は、OpenTofuが登録した公開鍵に対応する秘密鍵を指定する。SSH接続に`sudo`は必要ない。

| 項目 | 値 |
|---|---|
| 接続先 | `192.168.0.70` |
| 接続ユーザー | `ogs-digilife` |
| 秘密鍵 | `~/.ssh/id_homelab_ogs-digilife` |
| 対応する公開鍵 | `/opt/automation/keys/id_homelab_ogs-digilife.pub` |

```bash
ssh -i ~/.ssh/id_homelab_ogs-digilife \
  ogs-digilife@192.168.0.70
```

`ssh -i`には秘密鍵を指定する。`/opt/automation/keys/`にある`.pub`ファイルはVMへ登録するための公開鍵であり、SSH接続時のidentity fileとしては使用しない。

## 補足　OS imageファイルのソース

`https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img`
