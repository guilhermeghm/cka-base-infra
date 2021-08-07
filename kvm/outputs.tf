# Show the VMs IPs.
output "Controller_IP" {
  description = "IP of the first VM"
  value = libvirt_domain.k8s-cka_domain.0.network_interface.0.addresses
}

output "ips" {
  description = "IP list for all VMs."
  value =  libvirt_domain.k8s-cka_domain.*.network_interface.0.addresses
}
