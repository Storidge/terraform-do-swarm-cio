resource "digitalocean_floating_ip" "docker_swarm_master_ip" {
  count = var.swarm_master_count

  droplet_id = digitalocean_droplet.docker_swarm_master[count.index].id
  region = digitalocean_droplet.docker_swarm_master[count.index].region
}

