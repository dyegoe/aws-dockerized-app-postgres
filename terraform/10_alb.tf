resource "aws_lb" "main" {
  name               = "${var.project_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb.id}"]
  subnets            = ["${aws_subnet.public-a.id}", "${aws_subnet.public-b.id}"]

  enable_deletion_protection = true

  access_logs {
    bucket  = "${aws_s3_bucket.lb-logs.id}"
    prefix  = "${var.project_name}-lb"
    enabled = true
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-lb"
    )
  )}"
}

resource "aws_lb_target_group" "main" {
  name     = "${var.project_name}-lb-tg-main"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-lb-tg-main"
    )
  )}"
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = "${aws_lb.main.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main.arn}"
  }
}

output "aws_lb_dns_name" {
  value = "${aws_lb.main.dns_name}"
}
