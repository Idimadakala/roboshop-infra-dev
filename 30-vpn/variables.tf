variable "instance_type" {
    type = string
    default = "t3.micro"
}

variable "project" {
    default = "roboshop-infra"
  
}
variable "environment" {
  default = "dev"
}

variable "vpn_tags" {
    type = map(string)
    default = {}
}

variable "zone_id" {
  default = "Z03703982MKCR7DNXKOPG"
}

variable "zone_name" {
  default = "jsprajampeta.org"
}