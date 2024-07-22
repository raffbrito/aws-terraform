resource "aws_vpc" "mtc_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "dev"
    }
}

resource "aws_subnet" "mtc_public_subnet" {
    vpc_id = aws_vpc.mtc_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-2a"

    tags = {
        Name = "dev-public"
    }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
    vpc_id = aws_vpc.mtc_vpc.id

    tags = {
        Name = "dev-lgw"
    }
}

resource "aws_route_table" "mtc_public_rt" {
    vpc_id = aws_vpc.mtc_vpc.id

    tags = {
        Name = "dev_public_rt"
    }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.mtc_public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
    subnet_id = aws_subnet.mtc_public_subnet.id
    route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_security_group" "mtc_sg" {
  name        = "dev_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["74.105.82.66/32"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}