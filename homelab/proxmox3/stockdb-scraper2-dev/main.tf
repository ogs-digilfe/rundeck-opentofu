# main.tf
# Proxmox VE 上に Ubuntu 24.04 Server (cloud-init) のVMを1台作成する。

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = var.vm_name
  node_name = var.proxmox_node
  vm_id     = var.vm_id
  tags      = var.vm_tags
  started   = var.vm_started
  on_boot   = var.vm_on_boot

  # Proxmox3上のUbuntu 24.04 cloud-initテンプレートから完全クローンする。
  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.vm_cores
    type  = var.vm_cpu_type
  }

  memory {
    dedicated = var.vm_memory
  }

  scsi_hardware = "virtio-scsi-single"

  disk {
    datastore_id = var.vm_datastore_id
    interface    = "scsi0"
    size         = var.vm_disk_size
    discard      = "on"
    ssd          = true
  }

  network_device {
    bridge  = var.vm_bridge
    model   = "virtio"
    vlan_id = var.vm_vlan_id
  }

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = var.vm_datastore_id

    ip_config {
      ipv4 {
        address = "${var.vm_ip}/${var.vm_cidr_bits}"
        gateway = var.vm_gateway
      }
    }

    dns {
      servers = var.vm_dns
    }

    user_account {
      username = var.vm_username
      keys = [
        trimspace(file("/opt/automation/keys/id_homelab_ogs-digilife.pub")),
        trimspace(file("/opt/automation/keys/desktop-0i3anuu/ogs-digilife.pub")),
        trimspace(file("/opt/automation/keys/id_homelab_rundeck.pub"))
      ]
    }
  }
}
