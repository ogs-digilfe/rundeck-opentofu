# env.tfvars
# Proxmox環境共通設定

proxmox_endpoint = "https://192.168.0.180:8006"

# 検証環境のため自己署名証明書を許容
proxmox_insecure = true

# proxmoxデータセンタ2で管理しているproxmoxのnode名
proxmox_node = "proxmox2"

# guest vmの初期ユーザ
vm_username="ogs-digilife"


