#Set the required versions and the backend.
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}


#Define the connection.
provider "libvirt" {
  uri = "qemu:///system"
}
