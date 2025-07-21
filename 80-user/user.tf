module "user" {
    source = "git::https://github.com/Idimadakala/roboshop-infra-component-module.git?ref=develop"
    component = "user"
    rule_priority = 20
}