locals {
  ami_id = data.aws_ami.mongodb.id
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
  roboshop_database_subnet_id = split(",",data.aws_ssm_parameter.roboshop_database_subnet_ids.value)[0]

    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = true
    }
}