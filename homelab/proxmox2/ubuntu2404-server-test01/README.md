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
SSH認証方式 | 公開鍵認証のみ | guest VM作成直後は、このホスト(open tofuホスト)からしかログインできない。<br>別ホストからログインするには、このホストの秘密鍵(~/.ssh/id_rundeck)が必要


## 補足　OS imageファイルのソース

`https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img`
