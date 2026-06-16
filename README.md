# このリポジトリについて

## 概要

`open tofu`構成ファイルを管理するリポジトリ。

## ディレクトリ構成

### プロジェクトフォルダ構成

- プロジェクトフォルダの直下の階層は、構築環境単位とする。
- ここでは、プロジェクトルート(`opentofu`)でgitリポジトリを作成することとする。

```text
opentofu/
├── .gitignore
├── homelab/
├── aws/
:
```

### 環境単位のフォルダ構成

- 環境フォルダの直下の階層は、プロバイダ単位とする。  
- `secrets/`フォルダでは、環境固有であり、環境共通の機微データ(apiキーやログインパスワードなど)をopentofuホストの環境変数にセットするスクリプトファイルを管理する。
- プロバイダとは、仮想環境構築先の仮想化基盤のことで、同一のクレデンシャルで接続できる単位。

```text
opentofu/homelab
├── secrets/
├── proxmox1/
├── proxmox2/
:
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
├── ubuntu2404-server-test01/
├── web01/
:
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

プロバイダ単位のフォルダの配下に、各guest vm単位にフォルダを作成し、その中にguest vm用のopen tofuの構成ファイルを配置している。  
以下は、guest vm単位のフォルダ内の構成ファイル配置例。

```text
homelab/proxmox2/
├── env.tfvars # プロバイダ固有の変数のセット
├── ubuntu2404-server-test01/ # ここがguest vm単位のフォルダ
│   ├── main.tf
│   ├── variables.tf 
│   ├── ubuntu2404-server-test01.tfvars
│   ├── outputs.tf
│   └── README.md 
└── secrets/ 
    └── proxmox2.sh
```