data "aws_ssm_parameter" "vpc_id" {
    name = "/roboshop-infra/dev/vpc_id"
}