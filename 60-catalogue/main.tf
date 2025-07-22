# target group is our services
resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project}-${var.environment}-target-group"
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 120 # wait time before deregistering the instance
  
  health_check {
    path                = "/health"
    interval            = 5
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200-299"
    port                = 8080
  }
  tags = merge(local.common_tags, 
  {
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
    aws_instance.catalogue_service.id
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

# stop the catalogue service instance
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue_service.id
  state       = "stopped"
  depends_on = [terraform_data.catalogue]
}

# capture the ami
resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-catalogue-service"
  source_instance_id = aws_instance.catalogue_service.id
  depends_on = [aws_ec2_instance_state.catalogue]
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-catalogue-service-ami"
    }
  )
}


# delete the catalogue service instance
resource "terraform_data" "catalogue_delete" {
  triggers_replace = [
    aws_instance.catalogue_service.id
  ]
  
  # make sure you have aws configure in your laptop
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.catalogue_service.id}"
  }
  depends_on = [aws_ami_from_instance.catalogue]
}

# create launch template for catalogue service
resource "aws_launch_template" "catalogue" {
  name_prefix   = "${var.project}-${var.environment}-catalogue-launch-template"
  image_id      = aws_ami_from_instance.catalogue.id
  instance_type = var.instance_type
  #key_name      = var.key_name
  vpc_security_group_ids = [local.catalogue_sg_id]
  instance_initiated_shutdown_behavior = "terminate"
  update_default_version = true # each time you update, new version will become default
  
  # instance tags created by ASG
  tag_specifications {
    resource_type = "instance"
    # EC2 tags created by ASG
    tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
      }
    )
  }

  # volume tags created by ASG
  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
      }
    )
  }
  # launch template tags
  tags = merge(local.common_tags, 
  {
    Name = "${var.project}-${var.environment}-catalogue-launch-template"
  })
}

# provide the launch template to autoscaling group
resource "aws_autoscaling_group" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue-asg"
  # pass the launch template to ASG
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
    #version = "$Latest" # use this if you want to use latest version of launch template
  }

  min_size             = 1
  max_size             = 10
  desired_capacity     = 1
  target_group_arns = [aws_lb_target_group.catalogue.arn]
  vpc_zone_identifier  = local.roboshop_private_subnet_ids

  health_check_grace_period = 90 # time to wait before checking health of instances
  #health_check_type         = "EC2" # can be ELB or EC2,
  health_check_type         = "ELB"

 dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${var.project}-${var.environment}-catalogue"
      }
    )
    content{
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
    
  }
  # enable instance refresh
  # this will update the instances in the ASG when launch template is updated
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  timeouts{
    delete = "15m"
  }
}

# autoscaling policy for catalogue service
resource "aws_autoscaling_policy" "catalogue" {
  name                   = "${var.project}-${var.environment}-catalogue"
  autoscaling_group_name = aws_autoscaling_group.catalogue.name # associate with ASG
  policy_type            = "TargetTrackingScaling"
  #cooldown               = 120
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}

# create listener rule for catalogue service
resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10 # least priority rule 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn # forward to catalogue target group
  }

  condition {
    host_header {
      values = ["catalogue.backend-${var.environment}.${var.zone_name}"]
    }
  }
}

