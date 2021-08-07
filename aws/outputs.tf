# Show the EC2 IPs.
output "Public_ip" {
  description = "IP list for all instances."
  value       = aws_instance.ec2-k8s-cka.*.public_ip
}

output "Controller_IP" {
  description = "IP of the first EC2."
  value = "To access the Controller VM: ssh -i k8s-cka.key ubuntu@${aws_instance.ec2-k8s-cka.0.public_ip}"
}