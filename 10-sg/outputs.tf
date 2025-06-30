output "frontend_security_group_id" {
    value = module.frontend.sg_id
}

output "bastion_security_group_id" {
    value = module.bastion.sg_id
}