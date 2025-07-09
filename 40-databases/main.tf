
# create mongodb instance in the database subnet
resource "aws_instance" "mongodb" {
  ami = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.mongodb_sg_id]
  # I want to create this instance in roboshop VPC database subnet, how to get the public subnet ? data source
  subnet_id = local.roboshop_database_subnet_id
  tags = merge(var.vpn_tags,
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
    source = "mongodb.sh"
    destination = "/tmp/mongodb.sh"
  }

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = self.private_ip
  }


  provisioner "remote-exec" {
    inline = [ 
      "chmod +x /tmp/mongodb.sh",
      "sudo sh /tmp/mongodb.sh"
     ]
  }
}