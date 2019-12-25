resource "digitalocean_ssh_key" "ssh_key" {
  name = "${var.swarm_name}-ssh-key"
  public_key = file(var.do_ssh_key_public)
}
