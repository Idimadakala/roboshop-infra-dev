output "frontend_alb_details" {
    value ={
        id = module.alb.id
        arn = module.alb.arn
        dns_name = module.alb.dns_name
    }
}

output "acm_arn" {
    sensitive = true
    description = "The ARN of the ACM certificate used by the frontend ALB"
    value = local.acm_arn
}