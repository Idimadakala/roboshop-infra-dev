# create mongodb instance in the database subnet
resource "aws_instance" "mongodb" {
  ami = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.mongodb_sg_id]
  # I want to create this instance in roboshop VPC database subnet, how to get the public subnet ? data source
  subnet_id = local.roboshop_database_subnet_id
  tags = merge(var.mongodb_tags,
    local.common_tags,{
    Name = "${var.project}-${var.environment}-mongodb"
  }
  )
}

# A use-case for terraform_data is as a do-nothing container
# for arbitrary actions taken by a provisioner.
resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mongodb.private_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"
     ]
  }
}

# create aws_route53_record for mongodb
resource "aws_route53_record" "mongodb_db_record" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

# create redis instance in the database subnet
resource "aws_instance" "redis" {
  ami = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.redis_sg_id]
  # I want to create this instance in roboshop VPC database subnet, how to get the public subnet ? data source
  subnet_id = local.roboshop_database_subnet_id
  tags = merge(local.common_tags,
  {
    Name = "${var.project}-${var.environment}-redis"
  }
  )
}

# A use-case for terraform_data is as a do-nothing container
# for arbitrary actions taken by a provisioner.
resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.redis.private_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
     ]
  }
}

# create aws_route53_record for redis
resource "aws_route53_record" "redis_db_record" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}

# create mysql instance in the database subnet
# fetch the role to fetch ssm parameters
resource "aws_instance" "mysql" {
  ami = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.mysql_sg_id]
  # I want to create this instance in roboshop VPC database subnet, how to get the public subnet ? data source
  subnet_id = local.roboshop_database_subnet_id
  iam_instance_profile = local.ec2_role_to_fetch_ssm_params
  tags = merge(local.common_tags,
  {
    Name = "${var.project}-${var.environment}-mysql"
  }
  )
}

# A use-case for terraform_data is as a do-nothing container
# for arbitrary actions taken by a provisioner.
 resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mysql.private_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
     ]
  }
}

# create aws_route53_record for mysql
resource "aws_route53_record" "mysql_db_record" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
  allow_overwrite = true
}

# create rabbitmq instance in the database subnet
resource "aws_instance" "rabbitmq" {
  ami = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  # I want to create this instance in roboshop VPC database subnet, how to get the public subnet ? data source
  subnet_id = local.roboshop_database_subnet_id
  tags = merge(local.common_tags,
  {
    Name = "${var.project}-${var.environment}-rabbitmq"
  }
  )
}

# A use-case for terraform_data is as a do-nothing container
# for arbitrary actions taken by a provisioner.
resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.rabbitmq.private_ip
  }
  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
     ]
  }
}

# create aws_route53_record for rabbitmq
resource "aws_route53_record" "rabbitmq_db_record" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}