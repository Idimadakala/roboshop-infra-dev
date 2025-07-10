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

# backend ALB accepting connections from vpn on port no 80
resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  #cidr_blocks       = ["0.0.0.0/0"]
  source_security_group_id = module.vpn.sg_id
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
module "mongodb" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.mongodb_sg_name
    sg_description = var.mongodb_sg_description
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# open port 22,27017 for mongodb
resource "aws_security_group_rule" "mongodb_open_ports" {
  count = length(var.mongodb_vpn_ports)
  type              = "ingress"
  from_port         = var.mongodb_vpn_ports[count.index]
  to_port           = var.mongodb_vpn_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mongodb.sg_id
}

# create sg for redis
module "redis" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.redis_sg_name
    sg_description = var.redis_sg_description
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# open port 6379 for redis
resource "aws_security_group_rule" "redis_open_ports" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.redis.sg_id
}

# create sg for mysql
module "mysql" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.mysql_sg_name
    sg_description = var.mysql_sg_description
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# open port 3306 for mysql
resource "aws_security_group_rule" "mysql_open_ports" {
  count = length(var.mysql_ports)
  type              = "ingress"
  from_port         = var.mysql_ports[count.index]
  to_port           = var.mysql_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mysql.sg_id
}

# create sg for rabbitmq
module "rabbitmq" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.rabbitmq_sg_name
    sg_description = var.rabbitmq_sg_description
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# open port 5672 for rabbitmq
resource "aws_security_group_rule" "rabbitmq_open_ports" {
  count = length(var.rabbitmq_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_ports[count.index]
  to_port           = var.rabbitmq_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.rabbitmq.sg_id
}

# services - 

#catalogue
module "catalogue" {
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "catalogue"
    sg_description = "for catalogue"
    vpc_id = local.vpc_id
}

#user
module "user" {
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "user"
    sg_description = "for user"
    vpc_id = local.vpc_id
}

# cart
module "cart" {
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "cart"
    sg_description = "for cart"
    vpc_id = local.vpc_id
}

#shipping
module "shipping" {
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "shipping"
    sg_description = "for shipping"
    vpc_id = local.vpc_id
}

#payment
module "payment" {
    source = "git::https://github.com/daws-84s/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "payment"
    sg_description = "for payment"
    vpc_id = local.vpc_id
}

