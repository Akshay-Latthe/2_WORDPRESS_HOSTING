resource "aws_db_subnet_group" "aurora_subnet_group" {
  name        = var.subnet_group_name # Provide a unique name
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids  = [aws_subnet.rds_subnet[0].id, aws_subnet.rds_subnet[1].id]
}

resource "aws_rds_cluster" "aurora_rds" {
  cluster_identifier      = var.cluster_name # Provide a unique name
  engine                  = var.engine
  engine_version          = var.engine_version
  availability_zones      = ["us-east-1b", "us-east-1c"]
  database_name           = var.database_name
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = var.retention_period
  preferred_backup_window = var.preferred_backup_window
  port                    = var.port_no
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds-sg.id]
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
  count                = 1
  identifier           = "aurora-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora_rds.id
  instance_class       = var.instance_class
  engine               = var.cluster_engine
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.aurora_subnet_group.name
  lifecycle {
    create_before_destroy = true
  }
}
