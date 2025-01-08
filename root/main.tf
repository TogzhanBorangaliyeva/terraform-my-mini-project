module "vpc" {
    source = "../vpc"
    vpc_cidr = var.root_vpc_cidr
    project_name = var.root_project_name
    cidr_public_subnet1 = var.root_cidr_public_subnet1
    cidr_public_subnet2 = var.root_cidr_public_subnet2
    cidr_private_subnet1 = var.root_cidr_private_subnet1
    cidr_private_subnet2 = var.root_cidr_private_subnet2
    cidr_route_table_private = var.root_cidr_route_table_private
    cidr_everywhere = var.root_cidr_everywhere
}