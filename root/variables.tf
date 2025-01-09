# Variables for VPC
variable "root_vpc_cidr" {}

variable "root_project_name" {}

variable "root_cidr_public_subnet1" {}

variable "root_cidr_public_subnet2" {}

variable "root_cidr_private_subnet1" {}

variable "root_cidr_private_subnet2" {}

variable "root_cidr_route_table_private" {}

variable "root_cidr_everywhere" {}

# Variable for RDS
variable "root_db_instance_name" {}

variable "root_db_allocated_storage" {}

variable "root_db_engine" {}

variable "root_db_engine_version" {}

variable "root_db_instance_class" {}

variable "root_secret_name" {}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}