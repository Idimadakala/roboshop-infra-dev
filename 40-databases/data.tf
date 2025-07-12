# joindevops ami_id
data "aws_ami" "mongodb" {
  owners           = ["973714476881"]
  most_recent      = true

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "mongodb_sg_id"{
    name = "/${var.project}/${var.environment}/mongodb_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id"{
    name = "/${var.project}/${var.environment}/redis_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id"{
    name = "/${var.project}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id"{
    name = "/${var.project}/${var.environment}/rabbitmq-sg-id"
}

data "aws_ssm_parameter" "roboshop_database_subnet_ids"{
    name = "/${var.project}/${var.environment}/roboshop_database_subnet_ids"
}

#fetch the role for ec2
data "aws_iam_role" "ec2_role_to_fetch_ssm_params" {
  name = "ec2-role-to-fetch-ssm-params"
}
