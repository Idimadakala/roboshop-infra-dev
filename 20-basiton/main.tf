resource "aws_instance" "bastion" {
  #ami           = data.aws_ami.joindevops.id
  ami = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.bastion_security_group_id]
  # I want to create this instance in roboshop VPC public subnet, how to get the public subnet ?
  subnet_id = local.roboshop_public_subnet_id
  tags = merge(var.bastion_tags,
    local.common_tags,{
    Name = "${var.project}-${var.environment}-bastion"
  }
  )
}