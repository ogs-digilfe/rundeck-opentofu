# outputs.tf

output "vm_summary" {
  description = "作成したVMの基本情報"

  value = {
    vm_id      = proxmox_virtual_environment_vm.ubuntu_vm.vm_id
    vm_name    = proxmox_virtual_environment_vm.ubuntu_vm.name
    node_name  = proxmox_virtual_environment_vm.ubuntu_vm.node_name
    ip_address = var.vm_ip
    username   = var.vm_username
  }
}

output "vm_ip" {
  description = "VMのIPアドレス"
  value       = var.vm_ip
}

output "vm_name" {
  description = "VM名"
  value       = proxmox_virtual_environment_vm.ubuntu_vm.name
}

output "vm_id" {
  description = "VMID"
  value       = proxmox_virtual_environment_vm.ubuntu_vm.vm_id
}

output "ssh_user" {
  description = "SSHログインユーザ"
  value       = var.vm_username
}