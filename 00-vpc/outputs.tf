output "vpc_id" {
    value ={
        vpc_id = module.vpc.vpc_id,
        public_subnet_ids = module.vpc.public_subnet_ids,
        private_subnet_ids = module.vpc.private_subnet_ids,
        database_subnet_ids = module.vpc.database_subnet_ids,
        public_rt_id = module.vpc.public_rt_id,
        private_rt_id = module.vpc.private_rt_id,
        database_rt_id = module.vpc.database_rt_id,
        igw_id = module.vpc.igw_id,
        eip_id = module.vpc.eip_id,
        nat_gateway_id = module.vpc.nat_gateway_id,
        vpc_peering_connection_id = module.vpc.vpc_peering_connection_id
    }   
}

/* output "azs_info" {
    value = module.vpc.azs_info
} */

output "vpc_peering_connection_id" {
    value = module.vpc.vpc_peering_connection_id
  
}