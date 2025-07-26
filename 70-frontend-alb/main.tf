module "alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = false #true
  version = "9.16.0"
  name    = "${var.project}-${var.environment}-frontend-alb"
  vpc_id  = local.vpc_id
  subnets = local.roboshop_public_subnet_ids
  create_security_group = false
  security_groups = [local.frontend_alb_sg_id]
  enable_deletion_protection = false
  
  tags = merge(local.common_tags,{
    Name = "${var.project}-${var.environment}-frontend-alb"
  })
}

# 2. ALB target group for the frontend
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = module.alb.arn
  port              = "443" # using HTTPS and for backend ALB it was HTTP:80
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # update with latest ssl policy
  certificate_arn   = local.acm_arn

  default_action {
    type             = "fixed-response" #  expected type to be one of ["forward" "authenticate-oidc" "authenticate-cognito" "redirect" "fixed-response"]
    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello I'm from the frontend-alb-listener navigation</h1>"
      status_code  = "200"
    }
    #target_group_arn = aws_lb_target_group.front_end.arn
  }
}

# Alias record for the ALB in Route 53
resource "aws_route53_record" "frontend_alb_alias" {
  zone_id = var.zone_id
  name    = "${var.environment}.${var.zone_name}" # e.g., dev.jsprajampeta.org
  type    = "A"

  alias {
    name                   = module.alb.dns_name # dns name of the ALB
    zone_id                = module.alb.zone_id # zone ID of the ALB
    evaluate_target_health = true
  }
}