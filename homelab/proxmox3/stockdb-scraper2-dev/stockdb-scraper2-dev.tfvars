# stockdb-scraper2-dev.tfvars
# VM固有設定

vm_id          = 124
vm_name        = "stockdb-scraper2-dev"
template_vm_id = 9100

vm_cores    = 4
vm_cpu_type = "x86-64-v2-AES"
vm_memory   = 32768

vm_disk_size    = 60
vm_datastore_id = "local-lvm"

vm_ip        = "192.168.0.124"
vm_cidr_bits = 24
vm_gateway   = "192.168.0.1"
vm_dns       = ["8.8.8.8"]
vm_bridge    = "vmbr0"
vm_vlan_id   = null

vm_on_boot = true
vm_started = true
vm_tags    = ["ubuntu", "cloud-init", "opentofu", "stockdb-scraper2-dev"]
