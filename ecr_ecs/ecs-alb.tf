resource "aws_alb" "alb-demo" {
  name               = "alb-demo"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    "${aws_subnet.public-subnet1.id}",
    "${aws_subnet.public-subnet2.id}"
  ]
  security_groups = ["${aws_security_group.sg-demo.id}"]
}

resource "aws_lb_target_group" "tg-demo-alb" {
  name        = "tg-demo-alb"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.diana-vpc.id

  health_check {
    healthy_threshold   = "5"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "demo-ear" {
  load_balancer_arn = aws_alb.alb-demo.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-demo-alb.id
  }
}


                                        
