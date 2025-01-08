resource "aws_vpc" "mp_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "mp_public_subnet1" {
  vpc_id     = aws_vpc.mp_vpc.id
  cidr_block = var.cidr_public_subnet1
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public_subnet1"
  }
}

resource "aws_subnet" "mp_public_subnet2" {
  vpc_id     = aws_vpc.mp_vpc.id
  cidr_block = var.cidr_public_subnet2
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public_subnet2"
  }
}

resource "aws_subnet" "mp_private_subnet1" {
  vpc_id     = aws_vpc.mp_vpc.id
  cidr_block = var.cidr_private_subnet1
  availability_zone = "us-east-2a"

  tags = {
    Name = "${var.project_name}-private_subnet1"
  }
}

resource "aws_subnet" "mp_private_subnet2" {
  vpc_id     = aws_vpc.mp_vpc.id
  cidr_block = var.cidr_private_subnet2
  availability_zone = "us-east-2b"

  tags = {
    Name = "${var.project_name}-private_subnet2"
  }
}

resource "aws_internet_gateway" "mp_gw" {
  vpc_id = aws_vpc.mp_vpc.id

  tags = {
    Name = "${var.project_name}-ig"
  }
}

resource "aws_route_table" "mp_route_table_public" {
  vpc_id = aws_vpc.mp_vpc.id

  route {
    cidr_block = var.cidr_everywhere
    gateway_id = aws_internet_gateway.mp_gw.id
  }

  tags = {
    Name = "${var.project_name}-rt-public"
  }
}

resource "aws_route_table" "mp_route_table_private" {
  vpc_id = aws_vpc.mp_vpc.id

  route {
    cidr_block = var.cidr_route_table_private
    gateway_id = "local"
  }

  tags = {
    Name = "${var.project_name}-rt-public"
  }
}

resource "aws_route_table_association" "mp_route_table_association_public1" {
  subnet_id      = aws_subnet.mp_public_subnet1.id
  route_table_id = aws_route_table.mp_route_table_public.id
}

resource "aws_route_table_association" "mp_route_table_association_public2" {
  subnet_id      = aws_subnet.mp_public_subnet2.id
  route_table_id = aws_route_table.mp_route_table_public.id
}

resource "aws_route_table_association" "mp_route_table_association_private1" {
  subnet_id      = aws_subnet.mp_private_subnet1.id
  route_table_id = aws_route_table.mp_route_table_private.id
}

resource "aws_route_table_association" "mp_route_table_association_private2" {
  subnet_id      = aws_subnet.mp_private_subnet2.id
  route_table_id = aws_route_table.mp_route_table_private.id
}

resource "aws_security_group" "mp_web_sg" {
  vpc_id = aws_vpc.mp_vpc.id
  name   = "${var.project_name}-web-sg"

  # Inbound rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_everywhere]  # Allows HTTP traffic from anywhere
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_everywhere]  # Allows HTTPS traffic from anywhere
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_everywhere]  # Limit SSH access to specific IP address for security
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_everywhere]  # Allows all outbound traffic (can be restricted if needed)
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}
