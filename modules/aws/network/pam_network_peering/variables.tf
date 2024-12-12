variable "action" {
  type = string
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "request_peer_vpc_id" {
  type    = string
  default = ""
}

variable "request_peer_region" {
  type    = string
  default = ""
}

variable "accept_pcx_id" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "security_group_ids" {
  type = map(string)
}

variable "subnet_cidr_map" {
  description = "Map of subnet names to their CIDR blocks"
  type        = map(string)
}

variable "sg_rules" {
  description = "Security rules for all components"
  type        = map(map(list(any)))
}