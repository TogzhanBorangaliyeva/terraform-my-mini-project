resource "aws_db_instance" "mp_rds" {
  identifier          = var.db_instance_name
  allocated_storage    = var.db_allocated_storage
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  db_subnet_group_name = aws_db_subnet_group.mp_subnet_group.name
  skip_final_snapshot  = true

  # Secrets Manager Integration
  username = jsondecode(data.aws_secretsmanager_secret_version.mp_db_secrets_version.secret_string).DB_USERNAME
  password = jsondecode(data.aws_secretsmanager_secret_version.mp_db_secrets_version.secret_string).DB_PASSWORD
}

resource "aws_db_subnet_group" "mp_subnet_group" {
  name       = "${var.db_instance_name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "MP DB subnet group"
  }
}

resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  description = "Allow MySQL inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_mysql"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_mysql_ipv4" {
  security_group_id = aws_security_group.allow_mysql.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_mysql.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_secretsmanager_secret" "mp_db_secrets" {
  name = var.secret_name
}

resource "aws_secretsmanager_secret_version" "mp_db_secrets_version" {
  secret_id     = aws_secretsmanager_secret.mp_db_secrets.id
  secret_string = var.secret_data
}
data "aws_secretsmanager_secret_version" "mp_db_secrets_version" {
  secret_id = aws_secretsmanager_secret.mp_db_secrets.id
}

resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "SecretsManagerAccessPolicy"
  description = "Allows access to Secrets Manager for specific secrets"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "arn:aws:secretsmanager:us-east-2:202533541498:secret:reviews-app-rds-secret-*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "user_secrets_manager_access" {
  user       = "togzhan01-admin" # Your IAM username
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
}

