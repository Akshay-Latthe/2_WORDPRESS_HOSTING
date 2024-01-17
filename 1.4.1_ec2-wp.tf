
resource "aws_launch_template" "wordpress" {
  depends_on = [aws_efs_mount_target.efs-mt-A,
    aws_efs_mount_target.efs-mt-B,
    aws_rds_cluster.aurora_rds,
  aws_elasticache_subnet_group.redis_subnet_group]
  image_id                = "ami-0a505deecbf0676f0" ##PACKER AMI
  instance_type           = "t2.micro"
  disable_api_termination = var.disable_api_termination
  key_name                = aws_key_pair.tera-key.key_name
  vpc_security_group_ids  = [aws_security_group.WS-SG.id]
  user_data = base64encode(templatefile("${path.module}/template_files/bootstrap_wp.tpl", {
    efs_name = aws_efs_file_system.wordpress_efs.dns_name,
    #efs_id       = aws_efs_file_system.wordpress_efs.id,
    #region       = var.region,
    #efs_location = var.efs_location,
    db_name     = var.database_name,
    db_user     = var.db_username,
    db_password = var.db_password,
    db_host     = aws_rds_cluster_instance.aurora_cluster_instance[0].endpoint,
    db_redis    = aws_rds_cluster.aurora_rds.endpoint
  }))
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WordPress-Instance"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}







/* data "template_file" "user_data" {
  template = file("${path.module}/template_files/bootstrap_wp.tpl")

  vars = {
    efs_name = aws_efs_file_system.wordpress_efs.dns_name
    efs_id = aws_efs_file_system.wordpress_efs.id
    region = var.region
    efs_location = var.efs_location
  }
}  */




















