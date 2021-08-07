# Show the EC2 IPs.
output "public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = aws_instance.ec2-k8s-cka.*.public_ip
}