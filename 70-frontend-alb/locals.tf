locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.id
  roboshop_public_subnet_ids = split(",",data.aws_ssm_parameter.roboshop_public_subnet_ids.value)
  frontend_alb_sg_id = data.aws_ssm_parameter.frontend_sg_id.id
  acm_arn = data.aws_ssm_parameter.acm_arn.value

    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = true
    }
}