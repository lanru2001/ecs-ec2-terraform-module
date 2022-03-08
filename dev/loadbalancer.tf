#ALB 
resource "aws_lb" "cw_lb" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.cw_alb.id]
  subnets            = [aws_subnet.app_public_subnets[0].id, aws_subnet.app_public_subnets[1].id]

  enable_deletion_protection = false
}

#ALB target group
resource "aws_alb_target_group" "cw_alb_tg_group" {
  name = "${var.name}-tg"
  port = 80

  protocol    = "HTTP"
  vpc_id      = aws_vpc.app_vpc.id
  target_type = "instance"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  depends_on = [aws_lb.cw_lb]
}

resource "aws_alb_listener" "ecs_alb_http_listner" {
  load_balancer_arn = aws_lb.cw_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.cw_alb_tg_group.arn
  }

  depends_on = [aws_alb_target_group.cw_alb_tg_group]
}
