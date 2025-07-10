variable "frontend_sg_name" {
    default = "allow-http-and-ssh"
  
}
variable "frontend_sg_description" {
    default = "allow ingress traffic for http and ssh and all outgoing traffic"
  
}

/* variable "vpc_id" {
    default = data.aws_vpc.default.id
  
} */

variable "project" {
    default = "roboshop-infra"
  
}
variable "environment" {
  default = "dev"
}

variable "bastion_sg_name" {
    default = "allow-ssh"
  
}
variable "bastion_sg_description" {
    default = "allow ingress traffic for ssh and all outgoing traffic"
}

variable "backend_sg_name" {
    default = "allow-http-from-backend"
  
}
variable "backend_sg_description" {
    default = "allow ingress traffic for http and all outgoing traffic"
  
}

variable "vpn_sg_name" {
    default = "vpn"
  
}
variable "vpn_sg_description" {
    default = "VPN is for Forward proxy "  
}

variable "vpn_ports" {
    default = [22,443,1194,943]  
}

variable "mongodb_sg_name" {
    default = "mongodb"
  
}
variable "mongodb_sg_description" {
    default = "for mongodb"  
}

variable "mongodb_vpn_ports" {
    default = [22,27017]
}

variable "redis_sg_name" {
    default = "redis"
  
}
variable "redis_sg_description" {
    default = "for redis"  
}

variable "redis_ports" {
    default = [22,6379]
}

variable "mysql_sg_name" {
    default = "mysql"
  
}
variable "mysql_sg_description" {
    default = "for mysql"  
}

variable "mysql_ports" {
    default = [22,3306]
}

variable "rabbitmq_sg_name" {
    default = "rabbitmq"
  
}
variable "rabbitmq_sg_description" {
    default = "for rabbitmq"  
}

variable "rabbitmq_ports" {
    default = [22,5672]
}