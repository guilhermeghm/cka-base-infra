# Output Server IP
output "ips" {
  value = libvirt_domain.k8s-cka_domain.*.network_interface.0.addresses
}