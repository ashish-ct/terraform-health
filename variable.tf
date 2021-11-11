variable "region" {
  type    = string
}

variable "env_name" {
}
variable "vpc_cidr" {
  type        = string
}

# Declare the data source
data "aws_availability_zones" "azs" {
  state = "available"
}


variable "ami" {
}
variable "instance_type" {
}
variable "key_name" {
}

### rds
variable "allocated_storage" {
    type = string
}
variable "engine" {
}
variable "engine_version" {
}
variable "instance_class" {
}
variable "name" {
}
variable "username" {
}
variable "password" {
}
variable "parameter_group_name" {
type = string
}
variable "skip_final_snapshot" {
  type = bool
}
