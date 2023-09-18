resource "aws_autoscaling_attachment" "asg_attachment_website" {
  autoscaling_group_name = aws_autoscaling_group.ALB-group.id
  lb_target_group_arn    = aws_lb_target_group.my-target-group.arn
}

resource "aws_autoscaling_group" "ALB-group" {

  launch_template {
    name    = aws_launch_template.wordpress.name
    version = aws_launch_template.wordpress.latest_version
  }
  vpc_zone_identifier = local.privet_subnet_ids
  target_group_arns   = [aws_lb_target_group.my-target-group.arn]
  health_check_type   = "ELB"
  min_size            = 2
  desired_capacity    = 2
  max_size            = 8

  metrics_granularity = "1Minute"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "WP-AutoS-EC2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "wp_policy_up" {
  name                   = "wordpress-terraform"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ALB-group.name
}

resource "aws_cloudwatch_metric_alarm" "wordpress_cpu_alarm_up" {
  alarm_name          = "wordpress-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ALB-group.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.wp_policy_up.arn]
}



resource "aws_autoscaling_policy" "wp_policy_down" {
  name                   = "wordpress-terraform-down"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ALB-group.name
}

resource "aws_cloudwatch_metric_alarm" "wordpress_cpu_alarm_down" {
  alarm_name          = "wordpress-cpu-alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ALB-group.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.wp_policy_down.arn]
}
