variable "dns_domain" {
  description = "DNS domain name"
  default     = "k8s-cka.local"

}

variable "network_cidr" {
  description = "Network CIDR"
  default     = "10.16.0.0/24"
}

variable "network_mode" {
  description = "Network mode"
  default     = "nat"
}

variable "count_vms" {
  description = "number of virtual-machine of same type that will be created"
  default     = 4
}

variable "memory" {
  description = "The amount of RAM (MB) for a node"
  default     = 2048
}

variable "vcpu" {
  description = "The amount of virtual CPUs for a node"
  default     = 2
}

variable "pool_path" {
  description = "The path for the storage pool"
  default     = "/k8s-VMs"
}

