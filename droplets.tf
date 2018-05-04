data "digitalocean_image" "swarm_image" {
  name = "${var.do_image}"
}

resource "digitalocean_droplet" "docker_swarm_master" {
  count = 1
  name = "${format("${var.swarm_name}-master-%02d", count.index)}"

  image = "${data.digitalocean_image.swarm_image.image}"
  size = "${var.do_worker_size}"
  region = "${var.do_region}"
  private_networking = true

  ssh_keys = [
    "${digitalocean_ssh_key.ssh_key.id}"
  ]

  connection {
    user = "${var.do_user}"
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertise-addr ${self.ipv4_address}",
      "docker swarm join-token --quiet worker > ~/worker.token",
      "docker swarm join-token --quiet manager > ~/manager.token"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.do_user}@${self.ipv4_address}:worker.token ."
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.do_user}@${self.ipv4_address}:manager.token ."
  }
}

resource "digitalocean_droplet" "docker_swarm_worker" {
  count = "${var.swarm_worker_count}"
  name = "${format("${var.swarm_name}-worker-%02d", count.index)}"

  image = "${data.digitalocean_image.swarm_image.image}"
  size = "${var.do_worker_size}"
  region = "${var.do_region}"
  private_networking = true

  ssh_keys = [
    "${digitalocean_ssh_key.ssh_key.id}"]

  connection {
    user = "${var.do_user}"
    agent = true
  }

  provisioner "file" {
    source = "worker.token"
    destination = "worker.token"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token $(cat ~/worker.token) ${digitalocean_droplet.docker_swarm_master.ipv4_address}:2377"
    ]
  }
}
