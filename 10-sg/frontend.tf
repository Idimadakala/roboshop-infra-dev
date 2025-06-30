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