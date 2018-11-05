resource "digitalocean_droplet" "first-manager" {
  image  = "${var.image}"
  name   = "${var.name}-m1"
  region = "${var.region}"
  size   = "${var.size}"
  ssh_keys = ["${var.ssh_key_ids}"]
  private_networking = "true"

  provisioner "remote-exec" {
    script = "scripts/wait_for_instance.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "ufw allow 2377/tcp",
      "ufw allow 7946/tcp",
      "ufw allow 7946/udp",
      "ufw allow 4789/udp",
      "ufw reload",
      "docker swarm init --advertise-addr ${self.ipv4_address_private}",
      "docker network create --driver=overlay web"
    ]
  }
  provisioner "local-exec" {
    command = "sh ./add-first-manager.sh ${self.name} ${self.ipv4_address} ${self.ipv4_address_private}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "sh ./remove-first-manager.sh ${self.name} ${self.ipv4_address} ${self.ipv4_address_private}"
    on_failure = "continue"
  }
}

resource "digitalocean_droplet" "managers" {
  image  = "${var.image}"
  name   = "${var.name}-m${count.index + 2}"
  region = "${var.region}"
  size   = "${var.size}"
  ssh_keys = ["${var.ssh_key_ids}"]
  private_networking = "true"
  count = "${var.manager_count - 1}"
  depends_on = ["digitalocean_droplet.first-manager"]

  provisioner "remote-exec" {
    script = "scripts/wait_for_instance.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "ufw allow 2377/tcp",
      "ufw allow 7946/tcp",
      "ufw allow 7946/udp",
      "ufw allow 4789/udp",
      "ufw reload"
    ]
  }
  provisioner "local-exec" {
    command = "sh ./add-manager.sh ${self.name} ${self.ipv4_address} ${self.ipv4_address_private}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "sh ./remove-manager.sh ${self.name} ${self.ipv4_address} ${self.ipv4_address_private}"
    on_failure = "continue"
  }
}

resource "digitalocean_droplet" "workers" {
  image  = "${var.image}"
  name   = "${var.name}-w${count.index + var.max_manager_count + 1}"
  region = "${var.region}"
  size   = "${var.size}"
  ssh_keys = ["${var.ssh_key_ids}"]
  private_networking = "true"
  count = "${var.worker_count}"
  depends_on = ["digitalocean_droplet.first-manager"]

  provisioner "remote-exec" {
    script = "scripts/wait_for_instance.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "ufw allow 2377/tcp",
      "ufw allow 7946/tcp",
      "ufw allow 7946/udp",
      "ufw allow 4789/udp",
      "ufw reload"
    ]
  }
  provisioner "local-exec" {
    command = "sh ./add-worker.sh ${self.name} ${self.ipv4_address} ${self.ipv4_address_private}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "sh ./remove-worker.sh ${self.name} ${self.ipv4_address} ${self.ipv4_address_private}"
    on_failure = "continue"
  }
}
