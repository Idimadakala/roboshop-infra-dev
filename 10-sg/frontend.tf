#frontend-sg
module "frontend" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_description
    #vpc_id = data.aws_vpc.main.id
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# frontend_alb
module "frontend_alb" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    project = var.project
    environment = var.environment
    sg_name = "frontend-alb"
    sg_description = "for frontend alb"
    vpc_id = local.vpc_id
}

#Frontend ALB
resource "aws_security_group_rule" "frontend_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "frontend_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_alb.sg_id
}

#Frontend
resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_frontend_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend_alb.sg_id
  security_group_id = module.frontend.sg_id
}

#bastion-sg
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
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

resource "aws_security_group_rule" "backend_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_cart" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_shipping" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
  security_group_id = module.backend_alb.sg_id
}

resource "aws_security_group_rule" "backend_alb_payment" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
  security_group_id = module.backend_alb.sg_id
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
module "mongodb" {
    source = "git::https://github.com/Idimadakala/terrafrom-aws-resources.git//modules/securitygroup?ref=develop"
    sg_name = var.mongodb_sg_name
    sg_description = var.mongodb_sg_description
    vpc_id = local.vpc_id
    project = var.project
    environment = var.environment
}

# open port 22,27017 for mongodb-vpn
resource "aws_security_group_rule" "mongodb_open_ports_vpn" {
  count = length(var.mongodb_vpn_ports)
  type              = "ingress"
  from_port         = var.mongodb_vpn_ports[count.index]
  to_port           = var.mongodb_vpn_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mongodb.sg_id
}

# open port 22,27017 for mongodb-bastion
resource "aws_security_group_rule" "mongodb_bastion" {
  count = length(var.mongodb_vpn_ports)
  type              = "ingress"
  from_port         = var.mongodb_vpn_ports[count.index]
  to_port           = var.mongodb_vpn_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.mongodb.sg_id
}

# open port 27017 for mongodb-catalogue
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id
}

# open port 27017 for mongodb-user
resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
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

# open port 6379 for redis-vpn
resource "aws_security_group_rule" "redis_open_ports_vpn" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.redis.sg_id
}

# open port 6379 for redis-bastion
resource "aws_security_group_rule" "redis_open_ports_bastion" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.redis.sg_id
}

# open port 6379 for redis-user service
resource "aws_security_group_rule" "redis_open_port_user" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user.sg_id
  security_group_id = module.redis.sg_id
}

# open port 6379 for redis-cart service
resource "aws_security_group_rule" "redis_open_port_cart" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart.sg_id
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
resource "aws_security_group_rule" "mysql_open_ports_vpn" {
  count = length(var.mysql_ports)
  type              = "ingress"
  from_port         = var.mysql_ports[count.index]
  to_port           = var.mysql_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.mysql.sg_id
}

# open port 3306 for mysql
resource "aws_security_group_rule" "mysql_open_ports_bastion" {
  count = length(var.mysql_ports)
  type              = "ingress"
  from_port         = var.mysql_ports[count.index]
  to_port           = var.mysql_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.mysql.sg_id
}

# open port 3306 for mysql-shipping
resource "aws_security_group_rule" "mysql_open_port_shipping" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping.sg_id
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
resource "aws_security_group_rule" "rabbitmq_open_ports_vpn" {
  count = length(var.rabbitmq_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_ports[count.index]
  to_port           = var.rabbitmq_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.rabbitmq.sg_id
}

# open port 5672 for rabbitmq
resource "aws_security_group_rule" "rabbitmq_open_ports_bastion" {
  count = length(var.rabbitmq_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_ports[count.index]
  to_port           = var.rabbitmq_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.rabbitmq.sg_id
}

# open port 5672 for rabbitmq
resource "aws_security_group_rule" "rabbitmq_open_port_payment" {
  type              = "ingress"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment.sg_id
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

# catalogue - vpn - 22,8080
resource "aws_security_group_rule" "catalogue_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.catalogue.sg_id # its own source security group
}

resource "aws_security_group_rule" "catalogue_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.catalogue.sg_id # its own source security group
}

#catalogue - bastion: 22
resource "aws_security_group_rule" "catalogue_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source security group
  security_group_id = module.catalogue.sg_id # its own source security group
}

# ingress rules for catalogue service on ports - 8080, vpn - 22, 8080 and bastion - 22
resource "aws_security_group_rule" "catalogue_backend_alb_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id # source security group
  security_group_id = module.catalogue.sg_id # its own source security group
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

# user - vpn - 22,8080
resource "aws_security_group_rule" "user_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.user.sg_id # its own source security group
}

resource "aws_security_group_rule" "user_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.user.sg_id # its own source security group
}

#catalogue - bastion: 22
resource "aws_security_group_rule" "user_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source security group
  security_group_id = module.user.sg_id # its own source security group
}

resource "aws_security_group_rule" "user_backend_alb_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id # source security group
  security_group_id = module.user.sg_id # its own source security group
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

# user - vpn - 22,8080
resource "aws_security_group_rule" "cart_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.cart.sg_id # its own source security group
}

resource "aws_security_group_rule" "cart_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.cart.sg_id # its own source security group
}

#catalogue - bastion: 22
resource "aws_security_group_rule" "cart_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source security group
  security_group_id = module.cart.sg_id # its own source security group
}

resource "aws_security_group_rule" "cart_backend_alb_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id # source security group
  security_group_id = module.cart.sg_id # its own source security group
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

# shipping - vpn - 22,8080
resource "aws_security_group_rule" "shipping_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.shipping.sg_id # its own source security group
}

resource "aws_security_group_rule" "shipping_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.shipping.sg_id # its own source security group
}

#shipping - bastion: 22
resource "aws_security_group_rule" "shipping_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source security group
  security_group_id = module.shipping.sg_id # its own source security group
}

resource "aws_security_group_rule" "shipping_backend_alb_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id # source security group
  security_group_id = module.shipping.sg_id # its own source security group
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

# payment - vpn - 22,8080
resource "aws_security_group_rule" "payment_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.payment.sg_id # its own source security group
}

resource "aws_security_group_rule" "payment_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id # source security group
  security_group_id = module.payment.sg_id # its own source security group
}

#catalogue - bastion: 22
resource "aws_security_group_rule" "payment_bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id # source security group
  security_group_id = module.payment.sg_id # its own source security group
}

resource "aws_security_group_rule" "payment_backend_alb_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id # source security group
  security_group_id = module.payment.sg_id # its own source security group
}
