# # 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
   name        = "allow_web"
   description = "Allow Web inbound traffic"
   vpc_id      = aws_vpc.vpc.id

   ingress {
     description = "HTTPS"
     from_port   = 443
     to_port     = 443
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "HTTP"
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "SSH"
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "SSH"
     from_port   = 8000
     to_port     = 9000
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

      egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
     Name = "${var.env_name}-security_group"
   }
}
resource "aws_network_interface" "web" {
  subnet_id       = aws_subnet.subnet-pub.id
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "eip" {
  instance = aws_instance.web-server-instance.id
  vpc      = true
}

output "server_public_ip" {
   value = aws_eip.eip.public_ip
  }