#creating key pair
resource "aws_key_pair" "tera-key" {
  key_name   = "wordpress-01"
  public_key = file("${path.module}/id_rsa.pub") # file("${path.module}/id_rsa.pub")
}

## =====================================================Bastion-Host ec2 ============================================
resource "aws_instance" "Bastion-Host" {
  count                  = 1
  ami                    = var.ami_id
  instance_type          = var.public_ec2_type
  key_name               = aws_key_pair.tera-key.key_name ## aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.BH-SG.id]
  tags = {
    Name = "Bastion_Host_From_Terraform"
  }
  subnet_id = aws_subnet.public_subnet[count.index].id ## "${var.public_cidrs[count.index]}"
}
























