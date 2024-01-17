
variable "aws_region" {
  description = "The AWS region where the AMI will be created."
  default     = "us-east-1"
}

variable "aws_instance_type" {
  description = "The AWS instance type for the WordPress instance."
  default     = "t2.micro"
}

variable "ssh_username" {
  description = "The SSH username for connecting to the instance."
  default     = "ubuntu"
}

variable "source_ami" {
  description = "The source AMI ID for the base image."
  default     = "ami-053b0d53c279acc90"
}




packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "wordpress" {
  ami_name      = "wordpress-${local.timestamp}"
  source_ami    = var.source_ami
  instance_type = var.aws_instance_type
  region        = var.aws_region
  ssh_username  = var.ssh_username
}

build {
  name    = "My-First-Wordpres"
  sources = ["source.amazon-ebs.wordpress"]

  provisioner "shell" {
    script = "./app2.sh"
  }
}





