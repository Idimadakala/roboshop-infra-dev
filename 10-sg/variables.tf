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
    default = "allow-http-from-bastion"
  
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