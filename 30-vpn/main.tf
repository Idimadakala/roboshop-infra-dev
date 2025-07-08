# aws key-pair creation
resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("C:\\Users\\saisr\\OneDrive\\Documents\\ssi-solutions\\openvpn.pub")
}

resource "aws_instance" "vpn" {
  ami = local.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [local.vpn_sg_id]
  # I want to create this instance in roboshop VPC public subnet, how to get the public subnet ?
  subnet_id = local.roboshop_public_subnet_id
  
  key_name = aws_key_pair.openvpn.key_name
  user_data = file("openvpn.sh")
  
  tags = merge(var.vpn_tags,
    local.common_tags,{
    Name = "${var.project}-${var.environment}-openvpn"
  }
  )
}

