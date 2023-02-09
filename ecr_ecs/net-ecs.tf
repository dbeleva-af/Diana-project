resource "aws_vpc" "diana-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "Diana Project VPC"
  }
}
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.diana-vpc.id
  cidr_block              = var.public-subnet-cidr1
  map_public_ip_on_launch = "true"
  availability_zone       = var.az-1

  depends_on = [
    aws_vpc.diana-vpc,
  ]

  tags = {
    Name = "public subnet1"
  }
}
resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.diana-vpc.id
  cidr_block              = var.public-subnet-cidr2
  map_public_ip_on_launch = "true"
  availability_zone       = var.az-2


  depends_on = [
    aws_vpc.diana-vpc,
  ]

  tags = {
    Name = "public subnet2"
  }
}

resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.diana-vpc.id
  cidr_block        = var.private-subnet-cidr3
  availability_zone = var.az-1

  depends_on = [
    aws_vpc.diana-vpc,
  ]

  tags = {
    Name = "private subnet1"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.diana-vpc.id
  cidr_block        = var.private-subnet-cidr4
  availability_zone = var.az-2

  depends_on = [
    aws_vpc.diana-vpc,
  ]

  tags = {
    Name = "private subnet2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.diana-vpc.id

  depends_on = [aws_vpc.diana-vpc]
}
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.diana-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "igw route table"
  }
}

resource "aws_route_table_association" "public-subnet1-associ" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.rt-1.id
}

resource "aws_route_table" "rt-2" {
  vpc_id = aws_vpc.diana-vpc.id

  route {
    cidr_block = "0.0.0.0/0"

   gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "igw route table2"
  }
}

resource "aws_eip" "ip1-demo" {
  vpc = true
}
resource "aws_nat_gateway" "natgw-1" {
  subnet_id     = aws_subnet.public-subnet1.id
  allocation_id = aws_eip.ip1-demo.id

  tags = {
    Name = "NAT1"
  }
}

resource "aws_route_table" "natrt-1" {
  vpc_id = aws_vpc.diana-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw-1.id
  }

  tags = {
    Name = "NATrt-1"
  }
}

resource "aws_eip" "ip2-demo" {
  vpc = true
}

resource "aws_nat_gateway" "natgw-2" {
  subnet_id     = aws_subnet.public-subnet2.id
  allocation_id = aws_eip.ip2-demo.id

  tags = {
    Name = "NAT2"
  }
}

resource "aws_route_table" "natrt-2" {
  vpc_id = aws_vpc.diana-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw-2.id
  }

  tags = {
    Name = "NATrt-2"
  }
}

resource "aws_route_table_association" "asso-1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.natrt-1.id
}

resource "aws_route_table_association" "asso-2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.natrt-2.id
}

resource "aws_security_group" "sg-demo" {
  name        = "cat-app-sg"
  description = "Allow TLS"
  vpc_id      = aws_vpc.diana-vpc.id
 ingress {
    description = "ICMP"
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-demo"
  }
}
