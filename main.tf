terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.64.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_host
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true

  ssh {
    agent    = true
    username = "root"
  }
}

module "proxy" {
  source = "./modules/proxy"
}

