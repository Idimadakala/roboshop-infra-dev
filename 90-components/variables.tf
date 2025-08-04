variable "components" {
    default = {
        catalogue = {
            component_name = "catalogue"
            instance_type  = "t3.micro"
            key_name       = "roboshop-key"
            rule_priority  = 10
        },
        user = {
            component_name = "user"
            instance_type  = "t3.micro"
            key_name       = "roboshop-key"
            rule_priority  = 20
        }
        cart = {
            component_name = "cart"
            instance_type  = "t3.micro"
            key_name       = "roboshop-key"
            rule_priority  = 30
        },
        shipping = {
            component_name = "shipping"
            instance_type  = "t3.micro"
            key_name       = "roboshop-key"
            rule_priority  = 40
        },
        payment = {
            component_name = "payment"
            instance_type  = "t3.micro"
            key_name       = "roboshop-key"
            rule_priority  = 50
        },
        frontend = {
            component_name = "frontend"
            instance_type  = "t3.micro"
            key_name       = "roboshop-key"
            rule_priority  = 60  # rule_priority: This is used to determine the order of the rules in the load balancer
        }
    }
  
}