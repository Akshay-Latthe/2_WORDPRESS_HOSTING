
## ==== VPC's Default Security Group ======
resource "aws_security_group" "default" {
  name        = "default-vpc-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Name = "VPC-SG-01"
  }
}

## ===============================Bastion Host  ============================================================
# Creating security group for Bastion Host/Jump Box  
resource "aws_security_group" "BH-SG" {

  depends_on  = [aws_vpc.vpc]
  description = "MySQL Access only from the Webserver Instances!"
  name        = "bastion-host-sg"
  vpc_id      = aws_vpc.vpc.id

  # Created an inbound rule for Bastion Host SSH
  ingress {
    description = "Bastion Host SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "output from Bastion Host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## ==========# ### security_group for load balancer   ==================================================================
resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [80, 443]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


# Creating a Security Group for ========================  WordPress  ==================================================
resource "aws_security_group" "WS-SG" {
  depends_on = [
    aws_vpc.vpc,
    aws_security_group.alb-sg,
    aws_security_group.BH-SG
  ]
  description = "HTTP, SSH"
  name        = "webserver-sg"
  vpc_id      = aws_vpc.vpc.id

  # Created an inbound rule for SSH
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp" # Here adding tcp instead of ssh, because ssh in part of tcp only!
    security_groups = [aws_security_group.BH-SG.id]
  }
  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }
  # Created an inbound rule for webserver access!
  ingress {
    description     = "HTTP for webserver"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp" # Here adding tcp instead of http, because http in part of tcp only!
    security_groups = [aws_security_group.alb-sg.id]
  }

  # Outward Network Traffic for the WordPress
  egress {
    description = "output from webserver"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### ===================================Aurora RDS-sg ============================================
resource "aws_security_group" "rds-sg" {
  name        = "MySQL-SG"
  description = "allow SSH from Controller and MySQL from my IP and from web servers"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.WS-SG.id}"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "MySQL-DB-SG"

  }
}

### =================================== EFS-sg ============================================
resource "aws_security_group" "efs-sg" {
  name   = "ingress-efs-sg"
  vpc_id = aws_vpc.vpc.id

  // NFS
  ingress {
    security_groups = ["${aws_security_group.BH-SG.id}", "${aws_security_group.WS-SG.id}"]
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
  }

  egress {
    security_groups = ["${aws_security_group.BH-SG.id}", "${aws_security_group.WS-SG.id}"]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
  tags = {
    Name = "MyEFS-SG"

  }
}

## =============================  redis_sg  

resource "aws_security_group" "redis_sg" {
  name        = "redis_sg"
  description = "Opening redis port for wordpress autoscaling group security group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}", "${aws_security_group.WS-SG.id}"]
  }
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp" # Here adding tcp instead of ssh, because ssh in part of tcp only!
    security_groups = [aws_security_group.BH-SG.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}