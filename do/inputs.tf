variable "image" {
  description = "The image used for the server instances."
  default = "docker-16-04"
}

variable "name" {
  description = "A name for this cluster."
  default = "docker-swarm"
}

variable "region" {
  description = "The DigitalOcean region."
  default = "nyc3"
}

/**
 * Ref: https://www.terraform.io/docs/providers/do/r/droplet.html#size
 */
variable "size" {
  description = "The unique slug that indentifies the type of Droplet."
  default = "2gb"
}

/**
 * Ref: https://www.terraform.io/docs/providers/do/r/droplet.html#ssh_keys
 */
variable "ssh_key_ids" {
  description = "A list of SSH IDs or fingerprints of DigitalOcean keys to add to docker cluster servers."
  default = []
}

variable "manager_count" {
  description = "The number of manager nodes. Should be an odd number."
  default = "1"
}

variable "worker_count" {
  description = "The number of worker nodes."
  default = "0"
}

variable "max_manager_count" {
  description = "The maximun number of manager nodes ever expected. Only used to determine worker hostnames."
  default = "10"
}
