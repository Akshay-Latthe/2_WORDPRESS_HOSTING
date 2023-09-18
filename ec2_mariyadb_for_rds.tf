## ========================== marid_db ec2  ==========================================================

/* resource "aws_instance" "marid_db" {
  depends_on = [aws_efs_file_system.wordpress-efs]  
  ami           = var.mysql_ami_id
  instance_type = var.rds_ec2_type 
  key_name      = aws_key_pair.tera-key.key_name  ##aws_key_pair.deployer.key_name
  vpc_security_group_ids =["${aws_security_group.mariyadb-sg.id}"]
  tags = {
    Name = "ak-marid_db-ec2"
  }
  subnet_id = "${aws_subnet.rds_subnet[0].id}"
  #user_data = data.template_file.bootstrap-db.rendered
}  */
## ==========================================================================================================
/* data "template_file" "bootstrap-db" {
  template = file("bootstrap_mariadb.tpl")
  
  vars = {
    efs_id        = aws_efs_file_system.wordpress-efs.id
    root_password = var.root_password
    user          = var.user
    password      = var.password
    dbname        = var.dbname
  }
} */
## ==========================================================================
## security_group ==========================================  "MySQL-RDS" ==================================================
/* resource "aws_security_group" "mariyadb-sg" {
  description = "MySQL  DB INSTANCE SG!"
  name_prefix = "my-rds-sg-"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "MySQL Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.WS-SG.id]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.BH-SG.id]
  }
  egress {
    description = "output from MySQL BH"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}  */
