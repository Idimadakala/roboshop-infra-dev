#fetch our roboshop vpc_id for ALB
data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
}

#fetch our roboshop-infra VPC Private subnets
data "aws_ssm_parameter" "roboshop_private_subnet_ids"{
    name = "/${var.project}/${var.environment}/roboshop_private_subnet_ids"
}

data "aws_ssm_parameter" "backend_alb_sg_id"{
    name = "/${var.project}/${var.environment}/backend_alb_sg_id"
}