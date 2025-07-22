# how to debug ?
1. checking communication between catalogue and mongodb ?
# how to check the IP details for a domain
-> nslookup [domain] - Query DNS for domain details 
-> nslookup mongodb-dev.jsprajampeta.org
# nslookup for address translation to ipaddr
# ensure hostname resolves to a valid IP
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

