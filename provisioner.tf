resource "null_resource" "master_init" {
  count = var.swarm_master_count

  triggers = {
    cluster_instance_ids = digitalocean_droplet.docker_swarm_master.*.id[0]
  }

  connection {
    host  = digitalocean_droplet.docker_swarm_master.*.ipv4_address[0]
    user  = var.do_user
    agent = true
  }

  provisioner "local-exec" {
    command = "scripts/master.init.sh ${var.do_user} ${digitalocean_droplet.docker_swarm_master.*.ipv4_address[0]} ${digitalocean_droplet.docker_swarm_master.*.ipv4_address_private[0]}"
  }
}

resource "null_resource" "worker_init" {
  count = var.swarm_worker_count

  triggers = {
    cluster_instance_ids = digitalocean_droplet.docker_swarm_worker.*.id[count.index]
  }

  connection {
    timeout = "2m"
    host    = digitalocean_droplet.docker_swarm_worker.*.ipv4_address[count.index]
    user    = var.do_user
    agent   = true
  }

  provisioner "remote-exec" {
    when       = destroy
    on_failure = continue
    inline     = [
        "timeout 120 cioctl remove"
    ]
  }

  provisioner "local-exec" {
    command = "scripts/worker.init.sh ${var.do_user} ${digitalocean_droplet.docker_swarm_worker.*.ipv4_address[count.index]} ${digitalocean_droplet.docker_swarm_worker.*.ipv4_address_private[count.index]} ${digitalocean_droplet.docker_swarm_master.*.ipv4_address[0]}"
  }

  depends_on = [
    digitalocean_droplet.docker_swarm_master
  ]
}

resource "null_resource" "master_deploy" {
  triggers = {
    cluster_instance_ids = null_resource.worker_init.*.id[0]
  }

  connection {
    host  = digitalocean_droplet.docker_swarm_master.*.ipv4_address[0]
    user  = var.do_user
    agent = true
  }

  provisioner "local-exec" {
    command = "scripts/master.start.sh ${var.do_user} ${digitalocean_droplet.docker_swarm_master.*.ipv4_address[0]} ${digitalocean_droplet.docker_swarm_master.*.ipv4_address_private[0]}"
  }
}
