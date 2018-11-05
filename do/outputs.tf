output "master_ip" {
  value = "${digitalocean_droplet.first-manager.ipv4_address}"
}
