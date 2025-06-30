output "vpc_id" {
    value = module.vpc.vpc_id
  
}

output "igw_id" {
    value = module.vpc.igw_id
  
}

/* output "azs_info" {
    value = module.vpc.azs_info
  
} */
output "eip_id" {
    value = module.vpc.eip_id
}

output "nat_gateway_id" {
    value = module.vpc.nat_gateway_id
}

output "public_subnet_ids" {
    value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
    value = module.vpc.database_subnet_ids
}

output "public_rt_id" {
    value = module.vpc.public_rt_id
}

output "private_rt_id" {
    value = module.vpc.private_rt_id
}

output "database_rt_id" {
    value = module.vpc.database_rt_id
}

output "vpc_peering_connection_id" {
    value = module.vpc.vpc_peering_connection_id
  
}