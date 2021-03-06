# Digital Ocean Setup

variable "do_token" {
  default = "do_token"
}

variable "ssh_fingerprint" {
  default = "ssh_fingerprint"
}

variable "pub_key" {
  default = "pub_key"
}

variable "pvt_key" {
  default = "pvt_key"
}

variable "do_region" {
  default = "sfo2"
}

variable "do_image" {
  default = "cio-3450-u16"
}

variable "do_worker_size" {
  default = "2GB"
}

variable "do_ssh_key_public" {
  default = "/root/.ssh/id_rsa.pub"
}

variable "do_user" {
  default = "root"
}

## Swarm setup

variable "swarm_name" {
  default = "testcluster"
}

variable "swarm_master_count" {
  default = "1"
}

variable "swarm_worker_count" {
  default = "4"
}

variable "swarm_worker_storage_size" {
  default = "20"
}
