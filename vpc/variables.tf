variable "vpc_cidr" {
  description = "CIDR Block for VPC"  
}

variable "project_name" {
  description = "Project name for tagging resources"  
}

variable "cidr_public_subnet1" {}  

variable "cidr_public_subnet2" {}  

variable "cidr_private_subnet1" {}  

variable "cidr_private_subnet2" {}  

variable "cidr_route_table_private" {}  

variable "cidr_everywhere" {}  
