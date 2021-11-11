# # 9. Create Ubuntu server and install/enable apache2

resource "aws_instance" "web-server-instance" {
   ami               = var.ami
   instance_type     = var.instance_type
   availability_zone = data.aws_availability_zones.azs.names[0]
   key_name          = var.key_name

network_interface {
     device_index         = 0
     network_interface_id = aws_network_interface.web.id
   }

   user_data = <<-EOF
                 #!/bin/bash
                 sudo apt update -y
                 sudo apt install apache2 -y
                 sudo systemctl start apache2
                 sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                 sudo apt install openjdk-11-jre-headless -y
                 sudo apt-get update -y
                 sudo apt install docker.io -y
                 sudo snap install docker -y
                 EOF

   tags = {
     Name = "${var.env_name}-web-server"
   }
}