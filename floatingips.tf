resource "digitalocean_floating_ip" "docker_swarm_master_ip" {
  droplet_id = "${digitalocean_droplet.docker_swarm_master.id}"
  region = "${digitalocean_droplet.docker_swarm_master.region}"
}

