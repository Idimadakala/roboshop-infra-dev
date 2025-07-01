locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.id
  roboshop_private_subnet_ids = split(",",data.aws_ssm_parameter.roboshop_private_subnet_ids.value)
  #roboshop_private_subnet_id = split(",",data.aws_ssm_parameter.roboshop_private_subnet_ids.value)[0]
  backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value

    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = true
    }
}