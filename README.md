# how to debug ?
1. checking communication between catalogue and mongodb ?
# how to check the IP details for a domain
-> nslookup [domain] - Query DNS for domain details 
-> nslookup mongodb-dev.jsprajampeta.org
# nslookup for address translation to ipaddr. Ensure hostname resolves to a valid IP
telnet - mongodb-dev.jsprajampeta.org 27017 (To get the connection details)
netcat - 


nslookup mysql.jsprajampeta.org - Resolves DNS with valid IP

2. checking communication between user and mongodb, redis ?
nslookup redis-dev.jsprajampeta.org

3. checking communication between cart and redis ?
4. checking communication between shipping and mysql  ?
5. checking communication between payment and rabbitmq ?

# roboshop infra setup & configuration through Ansible

.crt --> public
.key --> private

certificate Authority - lets encrypt, 

Amazon certificate management (ACM)
public certificate

SSL Termination (load balancer)

On terraform init - Initialize the backend, module, provider plugin will be updated.

# on applying the 30-vpn, connect to the vpn by providing the URL - vpn-dev.jsprajampeta.org and password - Openvpn@123
-> vpn is forward proxy. It pretends that your in the host network.
-> To test, know my ip address in google chrome # Amazon Data Services NoVa
# on applying the 40-databases, all databases will start running on 4 different ec2-instances
# on applying the 50-backend-alb, alb, listener, route53_record will be provisioned
-> *.backend-dev.jsprajampeta.org or joindevops.backend-dev.jsprajampeta.org return the fixed-response
-> expose the backend-alb-listener-arn: arn:aws:elasticloadbalancing:us-east-1:998645338697:listener/app/roboshop-infra-dev-backend-alb/a7d100cb41ebf110/7920f39fb5a85af2
# on applying the 60-acm, acm certificate will be provisioned and acm arn is exposed to SSM parameter store
# on applying the 60-catalogue, catalogue instance will be provisioned. catalogue.backend-dev.jsprajampeta.org will return the fixed-response.
# http://catalogue.backend-dev.jsprajampeta.org/health
# http://catalogue.backend-dev.jsprajampeta.org/health/ - mongo=true
# http://catalogue.backend-dev.jsprajampeta.org/products
# on applying the 70-frontend-alb, alb, listener on 443, route53_record - dev.jsprajampeta.org are provisioned
-> dev.jsprajampeta.org will return the fixed response 
-> https://dev.jsprajampeta.org/ will return fixed-response
-> frontend.backend-dev.jsprajampeta.org

-> http://catalogue.backend-dev.jsprajampeta.org/products
-> http://user.backend-dev.jsprajampeta.org/health
-> http://cart.backend-dev.jsprajampeta.org/health
-> http://shipping.backend-dev.jsprajampeta.org/health
-> http://payment.backend-dev.jsprajampeta.org/health

#rule_priority: determines the order of the rules of load balancer

# steps to define TG, ec2-instance, stop and create AMI, ASG, policies, listener rules
1. aws_lb_target_group
2. aws_instance
3. null_resource is replaced with terraform_data (login and     configure the service instance)
4. aws_ec2_instance_state
5. aws_ami_from_instance
6. terraform_data (to terminate the service instance)
7. aws_launch_template (create launch temp for the service)
8. aws_autoscaling_group (provide the launch template to autoscaling group)
9. aws_autoscaling_policy (asg for service instance)
10. aws_lb_listener_rule (listener rules for the service instance)