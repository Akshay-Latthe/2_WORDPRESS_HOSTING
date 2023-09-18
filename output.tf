output "alb_target_group_arn" {
  value = aws_lb_target_group.my-target-group.arn
}
output "efs_id" {
  value = aws_efs_file_system.wordpress_efs.id
}
output "efs_dns_name" {
  value = aws_efs_file_system.wordpress_efs.dns_name
}

output "rds_endpoint" {
  value = aws_rds_cluster_instance.aurora_cluster_instance[0].endpoint
}

output "redis_endpoint" {
  value = aws_rds_cluster.aurora_rds.endpoint
}