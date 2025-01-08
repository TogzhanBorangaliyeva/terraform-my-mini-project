output "vpc_id" {
  value = aws_vpc.mp_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.mp_public_subnet1, aws_subnet.mp_public_subnet2]
}

output "private_subnet_ids" {
  value = [aws_subnet.mp_private_subnet1, aws_subnet.mp_private_subnet2]
}