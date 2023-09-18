resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.rds_subnet[0].id, aws_subnet.rds_subnet[1].id]
}

resource "aws_elasticache_replication_group" "instance" {
  count                         = 1
  node_type                     = "cache.t4g.micro"
  port                          = 6379
  parameter_group_name          = "default.redis7.cluster.on"
  replication_group_id          = "test"
  replication_group_description = "Redis cluster for Hashicorp ElastiCache WORDPRESS"
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = ["${aws_security_group.redis_sg.id}"]
  at_rest_encryption_enabled    = true
  multi_az_enabled              = true
  automatic_failover_enabled    = true
  apply_immediately             = true
  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups         = 1
  }
  lifecycle {
    ignore_changes = [
      cluster_mode,
    ]
  }
}
