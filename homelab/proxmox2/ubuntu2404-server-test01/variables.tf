# variables.tf

# /path/to/rundeck/automation/homelab/env.tfvars
variable "proxmox_endpoint" {
  description = "Proxmox API エンドポイント (例: https://192.168.0.180:8006/)"
  type        = string
}

# source /opt/rundeck/automation/homelab/secrets/proxmox2.sh
# sensitive = true は、plan/apply の表示でAPIトークンを秘匿する設定
variable "proxmox_api_token" {
  description = "Proxmox APIトークン (形式: user@realm!tokenid=secret)"
  type        = string
  sensitive   = true
}

# /path/to/rundeck/automation/homelab/env.tfvars
# trueにしたい場合は、値を指定すること
variable "proxmox_insecure" {
  description = "Proxmox API の自己署名証明書を許容するか"
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "VMを作成するProxmoxノード名"
  type        = string
}

variable "vm_id" {
  description = "作成するVMのVMID"
  type        = number
}

variable "vm_name" {
  description = "VM名 (= ホスト名)"
  type        = string
}

variable "template_vm_id" {
  description = "クローン元のProxmox VMテンプレートID"
  type        = number
}

variable "vm_cores" {
  description = "vCPUコア数"
  type        = number
}

variable "vm_memory" {
  description = "メモリ (MiB)"
  type        = number
}

variable "vm_disk_size" {
  description = "ディスクサイズ (GiB)"
  type        = number
}

variable "vm_ip" {
  description = "VMの固定IPアドレス"
  type        = string
}

variable "vm_cidr_bits" {
  description = "サブネットのプレフィックス長 (例: /24 なら 24)"
  type        = number
  default     = 24
}

variable "vm_gateway" {
  description = "デフォルトゲートウェイ"
  type        = string
  default     = "192.168.0.1"
}

variable "vm_dns" {
  description = "参照DNSサーバ"
  type        = string
  default     = "8.8.8.8"
}

variable "vm_username" {
  description = "cloud-initで作成するOS初期ユーザ名"
  type        = string
}

variable "vm_bridge" {
  description = "作成した仮想マシンの接続先nw(bridge)"
  type        = string
}