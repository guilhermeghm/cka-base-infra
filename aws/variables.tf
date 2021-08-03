#Set the number of EC2 instances
variable "instance_count" {
  default = "4"
}

#Set the EC2 type.
variable "instance_type" {
  default = "t3.small"
}