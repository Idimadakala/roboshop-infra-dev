module "frontend" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_description
    #vpc_id = data.aws_vpc.main.id
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

module "bastion" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_sg_description
    #vpc_id = data.aws_vpc.main.id
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# bastion accepting connections from my Mobaxterm locally
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

module "backend_alb" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.backend_sg_name
    sg_description = var.backend_sg_description
    #vpc_id = data.aws_vpc.main.id
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# backend ALB accepting connections from my bastion host on port no 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  #cidr_blocks       = ["0.0.0.0/0"]
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}