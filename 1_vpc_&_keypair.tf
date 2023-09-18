
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "akshay-vpc"
  }
}
## subnet ===================================================================================
resource "aws_subnet" "public_subnet" {
  count                   = 2
  cidr_block              = var.public_cidrs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public_sub-${count.index + 1}"
  }
}

resource "aws_subnet" "privet_subnet" {
  count             = 2
  cidr_block        = var.privet_cidrs[count.index]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "privet_sub-${count.index + 1}"
  }
}

resource "aws_subnet" "rds_subnet" {
  count             = 2
  cidr_block        = var.rds_cidrs[count.index]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "rds_sub-${count.index + 1}"
  }
}

## internet gateway ===================================================================================
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "wordpress-i-gw"
    env  = var.env
  }
}

## elastick ip  ===================================================================================
resource "aws_eip" "my-test-eip" {
  depends_on = [aws_internet_gateway.Igw]
  vpc        = true
  count      = 1
  tags = {
    Name = "wordperss-EIP${count.index + 1}"
  }
}


## nat getway for the privet subnet in PUBLIC SUBNET  ===================================================================================
resource "aws_nat_gateway" "my-test-nat-gateway" {
  count         = 1
  allocation_id = aws_eip.my-test-eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name = "Nat_gateway${count.index + 1}"
    Env  = var.env
  }
}



## VPC ROUTING  =================================================================================== 
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0" ## PUBLIC 
    gateway_id = aws_internet_gateway.Igw.id
  }
  tags = {
    Name = "public_route_BH"
  }
}

resource "aws_route_table" "privet_route" {
  vpc_id = aws_vpc.vpc.id
  count  = 1
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-test-nat-gateway[count.index].id
  }

  tags = {
    Name = "privet_route_WP"
  }
}

resource "aws_route_table" "rds_route" {
  vpc_id = aws_vpc.vpc.id
  count  = 1
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-test-nat-gateway[count.index].id
  }
  tags = {
    Name = "mariyadb_route_RDS"
  }
}

## Route Table  Association  ===================================================================================
resource "aws_route_table_association" "public_route_association" {
  count          = 2
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table_association" "privet_route_association" {
  count          = 2
  route_table_id = aws_route_table.privet_route[0].id
  subnet_id      = aws_subnet.privet_subnet[count.index].id
}

resource "aws_route_table_association" "rds_route_association" {
  count          = 2
  route_table_id = aws_route_table.rds_route[0].id
  subnet_id      = aws_subnet.rds_subnet[count.index].id
}



###Below code generate key and make key pair and also save the key in your local system

/* # Generate new private keyresource "tls_private_key" "my_key" {
resource "tls_private_key" "my_key" {
algorithm = "RSA"
rsa_bits  = 4096
}

# Generate a key-pair with above key
resource "aws_key_pair" "deployer" {
key_name   = "efs-key"
public_key = tls_private_key.my_key.public_key_openssh
}   

# Saving Key Pair for ssh login for Client if needed

resource "null_resource" "save_key_pair"  {
provisioner "local-exec" {
command = "echo  ${tls_private_key.my_key.private_key_pem} > mykey.pem"
}
} */

