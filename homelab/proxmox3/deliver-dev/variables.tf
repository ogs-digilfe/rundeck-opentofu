# variables.tf

variable "proxmox_endpoint" {
  description = "Proxmox APIエンドポイント"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox APIトークン (形式: user@realm!tokenid=secret)"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Proxmox APIの自己署名証明書を許容するか"
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

  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 999999999
    error_message = "vm_idは100以上999999999以下で指定してください。"
  }
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

variable "vm_cpu_type" {
  description = "Proxmoxへ指定するCPUタイプ"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "vm_memory" {
  description = "メモリ容量 (MiB)"
  type        = number
}

variable "vm_disk_size" {
  description = "ディスク容量 (GiB)"
  type        = number
}

variable "vm_datastore_id" {
  description = "OSディスクとcloud-initディスクを配置するProxmoxストレージID"
  type        = string
}

variable "vm_ip" {
  description = "VMの固定IPv4アドレス"
  type        = string
}

variable "vm_cidr_bits" {
  description = "IPv4サブネットのプレフィックス長"
  type        = number

  validation {
    condition     = var.vm_cidr_bits >= 0 && var.vm_cidr_bits <= 32
    error_message = "vm_cidr_bitsは0以上32以下で指定してください。"
  }
}

variable "vm_gateway" {
  description = "デフォルトゲートウェイのIPv4アドレス"
  type        = string
}

variable "vm_dns" {
  description = "参照するDNSサーバのリスト"
  type        = list(string)
}

variable "vm_username" {
  description = "cloud-initで作成するOS初期ユーザー名"
  type        = string
}

variable "vm_bridge" {
  description = "VMの接続先Proxmoxネットワークブリッジ"
  type        = string
}

variable "vm_vlan_id" {
  description = "VMへ割り当てるVLAN ID。VLANを使用しない場合はnull"
  type        = number
  default     = null

  validation {
    condition     = var.vm_vlan_id == null || (var.vm_vlan_id >= 1 && var.vm_vlan_id <= 4094)
    error_message = "vm_vlan_idはnull、または1以上4094以下で指定してください。"
  }
}

variable "vm_on_boot" {
  description = "Proxmoxノード起動時にVMを自動起動するか"
  type        = bool
  default     = true
}

variable "vm_started" {
  description = "VMを起動状態にするか"
  type        = bool
  default     = true
}

variable "vm_tags" {
  description = "VMへ設定するProxmoxタグ"
  type        = list(string)
  default     = ["ubuntu", "cloud-init", "opentofu", "deliver-dev"]
}
