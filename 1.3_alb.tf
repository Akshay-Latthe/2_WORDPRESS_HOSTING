# # Define the target group: This is going to provide a resource for use with Load Balancer
## =============================WORDPRESS_AUTOSCALING ==========================================
resource "aws_lb" "wordpress-alb" {
  name               = "wordperss-lb-tf"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = local.public_subnet_ids ## [aws_subnet.privet_subnet.*.id,aws_subnet.privet_subnet.*.id]   ##"${aws_subnet.privet_subnet}"
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "my-target-group" {
  health_check {
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 7
    interval            = 45
    matcher             = "200-499"
  }
  name        = "demo-tg-alb"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_lb_listener" "alb-htts-listner" {
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }

  }
}

resource "aws_lb_listener" "alb_https_listener" {
  depends_on        = [aws_route53_record.s3_alias]
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10" # Change to the appropriate SSL policy if needed
  certificate_arn   = aws_acm_certificate_validation.ssl_certificate_validation.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group.arn
  }
}






# # Provides the ability to register instances with an Application Load Balancer (ALB)
/* resource "aws_lb_target_group_attachment" "ec2-alb-tg-1" {
  count            = length(aws_instance.webserver)  
  target_group_arn = aws_autoscaling_group.ALB-group.arn   
  target_id        = aws_instance.webserver[count.index].id
} */

# Attach SSL Certificate to ALB HTTPS Listener

