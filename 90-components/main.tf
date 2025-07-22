module "user" {
    #source = "../../roboshop-infra-component-module"
    for_each = var.components
    source = "git::https://github.com/Idimadakala/roboshop-infra-component-module.git?ref=develop"
    component = each.key
    rule_priority = each.value.rule_priority
}