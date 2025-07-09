# joindevops ami_id
data "aws_ami" "mongodb" {
  owners            = ["679593333241"]
  most_recent       = true

  filter {
    name   = "name"
    #values = ["OpenVPN Access Server Community Image-8fbe3379-*"]
    values = ["OpenVPN Access Server Community Image-8fbe3379-63b6-43e8-87bd-0e93fd7be8f3"]
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

data "aws_ssm_parameter" "roboshop_database_subnet_ids"{
    name = "/${var.project}/${var.environment}/roboshop_database_subnet_ids"
}
