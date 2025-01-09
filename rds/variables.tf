variable "db_instance_name" {}

variable "db_allocated_storage" {}

variable "db_engine" {}

variable "db_engine_version" {}

variable "db_instance_class" {}

variable "private_subnet_ids" {}

variable "vpc_id" {}

variable "secret_name" {
  description = "The name of the secret in AWS Secrets Manager"
}

variable "secret_data" {
  description = "JSON-encoded secret data"
}