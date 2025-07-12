# target group is our services
resource "aws_lb_target_group" "catalogue" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path                = "/health"
    interval            = 5
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-299"
    port                = 8080
  }
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-${var.target_group_name}"
  })
}

# create catalogue service instance
resource "aws_instance" "catalogue_service" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id     = local.roboshop_private_subnet_ids[0]
  vpc_security_group_ids = [local.catalogue_sg_id]

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-catalogue-service"
  })
}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]
  
  provisioner "file" {
    source      = "catalogue.sh"
    destination = "/tmp/catalogue.sh"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue_service.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}