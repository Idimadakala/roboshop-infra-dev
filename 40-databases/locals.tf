locals {
  ami_id = data.aws_ami.mongodb.id
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
  redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
  mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
  rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
  roboshop_database_subnet_id = split(",",data.aws_ssm_parameter.roboshop_database_subnet_ids.value)[0]
  ec2_role_to_fetch_ssm_params = data.aws_iam_role.ec2_role_to_fetch_ssm_params.name

    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = true
    }
}