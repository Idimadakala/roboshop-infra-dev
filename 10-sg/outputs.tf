output "frontend_security_group_id" {
    value = module.frontend.sg_id
}

output "bastion_security_group_id" {
    value = module.bastion.sg_id
}

output "backend_alb_security_group_id" {
    value = module.backend_alb.sg_id
}

output "vpn_security_group_id" {
    value = module.vpn.sg_id
}

output "mongodb_security_group_id" {
    value = module.mongodb.sg_id
}