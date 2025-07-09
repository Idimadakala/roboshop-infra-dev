module "frontend" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_description
    #vpc_id = data.aws_vpc.main.id
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

#bastion
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

#backend_alb
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

# create sg for vpn
module "vpn" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.vpn_sg_name
    sg_description = var.vpn_sg_description
    #vpc_id = data.aws_vpc.main.id
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# open vpn ports on - 22,443,1194,943
resource "aws_security_group_rule" "vpn_open_ports" {
  count = length(var.vpn_ports)
  type              = "ingress"
  from_port         = var.vpn_ports[count.index]
  to_port           = var.vpn_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

# create sg for mongodb db
module "vpn" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.mongodb_sg_name
    sg_description = var.mongodb_sg_description
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# open port 22 for mongodb
resource "aws_security_group_rule" "mongodb_open_ports" {
  count = length(var.mongodb_vpn_ports)
  type              = "ingress"
  from_port         = var.mongodb_vpn_ports[count.index]
  to_port           = var.mongodb_vpn_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mongodb.sg_id
}

