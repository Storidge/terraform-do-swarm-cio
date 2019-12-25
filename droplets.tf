data "digitalocean_image" "swarm_image" {
  name = var.do_image
}

resource "digitalocean_droplet" "docker_swarm_master" {
  count = var.swarm_master_count
  name = format("${var.swarm_name}-master-%02d", count.index)

  image = data.digitalocean_image.swarm_image.image
  size = var.do_worker_size
  region = var.do_region
  private_networking = true

  volume_ids = [
    digitalocean_volume.storage01.*.id[count.index],
    digitalocean_volume.storage02.*.id[count.index],
    digitalocean_volume.storage03.*.id[count.index]
  ]

  ssh_keys = [
    digitalocean_ssh_key.ssh_key.id
  ]
}

resource "digitalocean_droplet" "docker_swarm_worker" {
  count = var.swarm_worker_count
  name = format("${var.swarm_name}-worker-%02d", count.index)

  image = data.digitalocean_image.swarm_image.image
  size = var.do_worker_size
  region = var.do_region
  private_networking = true

  volume_ids = [
    digitalocean_volume.storage01.*.id[count.index + var.swarm_master_count],
    digitalocean_volume.storage02.*.id[count.index + var.swarm_master_count],
    digitalocean_volume.storage03.*.id[count.index + var.swarm_master_count]
  ]

  ssh_keys = [
    digitalocean_ssh_key.ssh_key.id
  ]

  depends_on = [
    digitalocean_droplet.docker_swarm_master
  ]
}
