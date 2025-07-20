#fetch our roboshop vpc_id for ALB
data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
}

#fetch our roboshop-infra VPC public subnets
data "aws_ssm_parameter" "roboshop_public_subnet_ids"{
    name = "/${var.project}/${var.environment}/roboshop_public_subnet_ids"
}

data "aws_ssm_parameter" "frontend_alb_sg_id"{
    name = "/${var.project}/${var.environment}/frontend_alb_sg_id"
}

data "aws_ssm_parameter" "acm_arn"{
    name = "/${var.project}/${var.environment}/acm_arn"
}