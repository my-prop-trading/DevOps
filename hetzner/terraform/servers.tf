terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token   = var.hcloud_token
}


resource "hcloud_server" "pt" {
  count       = var.instances
  name        = "prop-t-${count.index}"
  image       = var.os_type
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [hcloud_ssh_key.default.id]
  labels = {
    type = "pt"
  }
}

resource "hcloud_network" "hc_private" {
  name     = "hc_private"
  ip_range = var.ip_range
}

resource "hcloud_server_network" "pt_network" {
  count     = var.instances
  server_id = hcloud_server.pt[count.index].id
  subnet_id = hcloud_network_subnet.hc_private_subnet.id
}

resource "hcloud_network_subnet" "hc_private_subnet" {
  network_id   = hcloud_network.hc_private.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.ip_range
}

resource "null_resource" "run_ansible" {
  count = var.instances

  provisioner "local-exec" {
    command = "sleep 20 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${join(",", hcloud_server.pt.*.ipv4_address)}' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' playbook.yml"
  }

  depends_on = [
    hcloud_server.pt,
  ]
}

