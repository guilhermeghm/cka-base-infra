#Get Linux AMI ID using SSM Parameter endpoint.
data "aws_ssm_parameter" "UbuntuAMI" {
  name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

#Cloud-init bootstrap file.
data "template_file" "user_data_k8s-cka" {
  template = file("k8s-cka.yaml")
}

#Set the SSH keypair.
resource "aws_key_pair" "k8s-cka" {
  key_name   = "k8s-cka"
  public_key = file("k8s-cka.pub")
}

#Creating and bootstrap EC2 instance.
#It will create all EC2 in the same subnet.
resource "aws_instance" "ec2-k8s-cka" {
  count                       = var.instance_count
  ami                         = data.aws_ssm_parameter.UbuntuAMI.value
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.k8s-cka.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg_ec2.id]
  subnet_id                   = aws_subnet.subnet1.id
  user_data                   = data.template_file.user_data_k8s-cka.rendered
  tags = {
    Name        = "k8s-cka-${count.index + 1}"
    Environment = "k8s-cka-ec2"
  }
}