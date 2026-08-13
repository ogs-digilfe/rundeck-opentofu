# deliver-dev.tfvars
# VM固有設定

vm_id          = 156
vm_name        = "deliver-dev"
template_vm_id = 9100

vm_cores    = 2
vm_cpu_type = "x86-64-v2-AES"
vm_memory   = 4096

vm_disk_size    = 32
vm_datastore_id = "local-lvm"

vm_ip        = "192.168.0.156"
vm_cidr_bits = 24
vm_gateway   = "192.168.0.1"
vm_dns       = ["8.8.8.8"]
vm_bridge    = "vmbr0"
vm_vlan_id   = null

vm_on_boot = true
vm_started = true
vm_tags    = ["ubuntu", "cloud-init", "opentofu", "deliver-dev"]
