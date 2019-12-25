resource "digitalocean_volume" "storage01" {
  count  = var.swarm_worker_count + var.swarm_master_count
  region = var.do_region
  name   = format("${var.swarm_name}-storage01-%02d", count.index)
  size   = var.swarm_worker_storage_size
}

resource "digitalocean_volume" "storage02" {
  count  = var.swarm_worker_count + var.swarm_master_count
  region = var.do_region
  name   = format("${var.swarm_name}-storage02-%02d", count.index)
  size   = var.swarm_worker_storage_size
}

resource "digitalocean_volume" "storage03" {
  count  = var.swarm_worker_count + var.swarm_master_count
  region = var.do_region
  name   = format("${var.swarm_name}-storage03-%02d", count.index)
  size   = var.swarm_worker_storage_size
}
