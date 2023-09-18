locals {
  public_subnet_ids = [for subnet in aws_subnet.public_subnet : subnet.id]
}
locals {
  privet_subnet_ids = [for subnet in aws_subnet.privet_subnet : subnet.id]
}

data "aws_kms_key" "efs" {
  key_id = "alias/aws/elasticfilesystem"
}
## ================================================EFS  ========================================================
resource "aws_efs_file_system" "wordpress_efs" {
  creation_token   = "wordpress-efs" # A unique name for the EFS file system
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  kms_key_id       = data.aws_kms_key.efs.arn
  lifecycle_policy {
    transition_to_ia = "AFTER_60_DAYS"
  }
  tags = {
    Name = "Wordpress-MyEFS"
  }
}
resource "aws_efs_backup_policy" "efs_backup_policy" {
  file_system_id = aws_efs_file_system.wordpress_efs.id

  backup_policy {
    status = "ENABLED"
  }
}
# Mounting EFS to the EC2 instance
resource "aws_efs_mount_target" "efs-mt-A" {
  depends_on      = [aws_efs_file_system.wordpress_efs]
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = aws_subnet.privet_subnet[0].id
  security_groups = ["${aws_security_group.efs-sg.id}"]
}

resource "aws_efs_mount_target" "efs-mt-B" {
  depends_on      = [aws_efs_file_system.wordpress_efs]
  file_system_id  = aws_efs_file_system.wordpress_efs.id
  subnet_id       = aws_subnet.privet_subnet[1].id
  security_groups = ["${aws_security_group.efs-sg.id}"]
}

resource "aws_efs_access_point" "efs_access" {
  depends_on = [
    aws_efs_file_system.wordpress_efs,
  ]
  file_system_id = aws_efs_file_system.wordpress_efs.id
}


## ==========================================
/* resource "null_resource" "wordpress_mount" {
  depends_on = [aws_instance.wordpress_instance, aws_efs_mount_target.wordpress_efs_mount]

  provisioner "local-exec" {
    command = "ssh ec2-user@${aws_instance.wordpress_instance.private_ip} 'sudo mkdir -p /var/www/html/wp-content/uploads && sudo mount -t efs ${aws_efs_file_system.wordpress_efs.dns_name}:/ /var/www/html/wp-content/uploads'"
  }
} */
## =====================================




### =========================================== ec2 =======================================================================
/* resource "aws_launch_template" "wordpress" {
  depends_on      = [aws_efs_file_system.wordpress-efs, aws_instance.marid_db ]
  image_id        = "ami-0ee9402e700a0dce1"
  instance_type   = "t2.micro"
 
  key_name = aws_key_pair.tera-key.key_name  ##aws_key_pair.deployer.key_name
  vpc_security_group_ids = [ "${aws_security_group.WS-SG.id}"]
  user_data              = base64encode("${data.template_file.bootstrap.rendered}")
  lifecycle {
    create_before_destroy = true
  }
}
 */



/* data "template_file" "bootstrap" {
  template = file("bootstrap_wp.tpl")
  vars = {
    efs_id   = "${aws_efs_file_system.wordpress-efs.id}"  

  }
} */



##sudo mount -t efs ${aws_efs_file_system.wordpress_efs.dns_name}:/ /var/www/html/wp-content/uploads


/* connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("E:/1workspace desktop/VPC-EC2-ALB-RDS/wordpress-01.pem")  
    host     = "${aws_launch_template.wordpress.private_ip}"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo su <<END",
      "apt-get install nfs-common -y",
      "efs_id=${aws_efs_file_system.wordpress-efs.id}",
      "mount -t efs $efs_id:/  /var/www/html/wp-content/uploads",
      "END",
    ]
} */







