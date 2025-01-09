output "endpoint" {
    value = aws_db_instance.mp_rds.endpoint
}

output "secret_arn" {
    value = aws_secretsmanager_secret.mp_db_secrets.arn
}