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

variable "mongodb_tags" {
    type = map(string)
    default = {}
  
}