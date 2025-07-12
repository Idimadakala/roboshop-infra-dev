output "backend_alb_id"{
    value = module.alb.id
}

output "dns" {
    value = module.alb.dns_name  
}