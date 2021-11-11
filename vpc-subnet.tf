provider "aws" {
  region     = var.region
}

# # 1. Create vpc
resource "aws_vpc" "vpc" {
   cidr_block = var.vpc_cidr
   tags = {
     Name = "${var.env_name}-vpc"
   }
 }

# # 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
   vpc_id = aws_vpc.vpc.id
}

# # 3. Create Custom Route Table
resource "aws_route_table" "route-table" {
   vpc_id = aws_vpc.vpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.gw.id
   }

   route {
     ipv6_cidr_block = "::/0"
     gateway_id      = aws_internet_gateway.gw.id
   }

   tags = {
     Name = "${var.env_name}-route_table"
   }
}
# # 4. Create a Subnet 
resource "aws_subnet" "subnet-pub" {
   vpc_id            = aws_vpc.vpc.id
   cidr_block        = "${cidrsubnet(var.vpc_cidr,8,0)}"
   availability_zone = data.aws_availability_zones.azs.names[0]

   tags = {
     Name = "${var.env_name}-subnet-pub"
   }
}

resource "aws_subnet" "subnet-pvt1" {
   vpc_id            = aws_vpc.vpc.id
   cidr_block        = "${cidrsubnet(var.vpc_cidr,8,1)}"
   availability_zone = data.aws_availability_zones.azs.names[0]

   tags = {
     Name = "${var.env_name}-subnet-pvt1"
   }
}

resource "aws_subnet" "subnet-pvt2" {
   vpc_id            = aws_vpc.vpc.id
   cidr_block        = "${cidrsubnet(var.vpc_cidr,8,2)}"
   availability_zone = data.aws_availability_zones.azs.names[1]

   tags = {
     Name = "${var.env_name}-subnet-pvt2"
   }
}

# # 5. Associate subnet with Route Table
resource "aws_route_table_association" "association" {
   subnet_id      = aws_subnet.subnet-pub.id
   route_table_id = aws_route_table.route-table.id
}