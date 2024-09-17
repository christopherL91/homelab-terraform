terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.64.0"
    }
  }
}

data "proxmox_virtual_environment_vm" "template" {
  node_name = "proxmox"
  vm_id     = 100
}

resource "proxmox_virtual_environment_vm" "proxy" {
  node_name   = "proxmox"
  name        = "proxy"
  description = "Managed by Terraform"
  tags        = ["opentofu", "ubuntu"]
  started     = true
  on_boot     = true

  operating_system {
    type = "l26"
  }

  agent {
    enabled = true
  }

  clone {
    vm_id = data.proxmox_virtual_environment_vm.template.vm_id
    full  = true
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    discard   = "on"
    interface = "scsi0"
    size      = 30
  }

  network_device {
    bridge   = "vnet1"
    firewall = false
    mtu      = 1450
  }

  initialization {
    ip_config {
      ipv4 {
        address = "10.0.1.2/24"
        gateway = "10.0.1.1"
      }
    }

    dns {
      servers = ["8.8.8.8", "8.8.4.4"]
    }
  }
}
