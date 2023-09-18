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
  source_ami    = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  region        = "us-east-1"
  ssh_username  = "ubuntu"
}

build {
  name    = "My-First-Wordpres"
  sources = ["source.amazon-ebs.wordpress"]

  provisioner "shell" {
    script = "./app2.sh"
  }
}





