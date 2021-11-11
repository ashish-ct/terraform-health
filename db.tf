# # 10 Subnet group for RDS

resource "aws_db_subnet_group" "default" {
  name        = "rds-subnet-group"
  description = "Terraform RDS subnet group"
  subnet_ids  = [aws_subnet.subnet-pvt1.id, aws_subnet.subnet-pvt2.id]

  tags = {
    Name = "${var.env_name}-My DB subnet group"
  }
}

# # 11 RDS security group in the VPC which our database will belong
resource "aws_security_group" "db-demo" {
  name        = "terraform_rds_security_group"
  description = "Terraform  RDS MySQL server"
  vpc_id      = aws_vpc.vpc.id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_name}-security-group-database"
  }
}

# # 12 configuring RDS

resource "aws_db_instance" "ct-db" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  db_subnet_group_name = aws_db_subnet_group.default.id
}