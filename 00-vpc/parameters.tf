resource "aws_ssm_parameter" "foo" {
  name  = "/${var.project}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "roboshop_public_subnet_ids" {
  name  = "/${var.project}/${var.environment}/roboshop_public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
  #type  = "String"
  #value = module.vpc.public_subnet_ids
}

resource "aws_ssm_parameter" "roboshop_private_subnet_ids" {
  name  = "/${var.project}/${var.environment}/roboshop_private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.roboshop_private_subnet_ids)
}