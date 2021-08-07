# Show the VMs IPs.
output "ips" {
  value = libvirt_domain.k8s-cka_domain.*.network_interface.0.addresses
}