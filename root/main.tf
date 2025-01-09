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

module "rds" {
    source = "../rds" 
    db_instance_name = var.root_db_instance_name
    db_allocated_storage = var.root_db_allocated_storage
    db_engine = var.root_db_engine
    db_engine_version = var.root_db_engine_version
    db_instance_class = var.root_db_instance_class
    secret_name = var.root_secret_name
    secret_data = jsonencode({
        DB_USERNAME = var.db_username
        DB_PASSWORD = var.db_password
        DB_NAME     = var.db_name
    })

    # Pass the private subnets output from the VPC module to the RDS module
    private_subnet_ids = module.vpc.private_subnet_ids
    vpc_id = module.vpc.vpc_id
}
