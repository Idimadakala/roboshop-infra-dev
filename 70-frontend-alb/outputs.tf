output "frontend_alb_details" {
    value ={
        id = module.alb.id
        arn = module.alb.arn
        dns_name = module.alb.dns_name
    }
}