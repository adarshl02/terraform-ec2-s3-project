resource "aws_vpc" "my-vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-my-vpc"
  }

}

resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-public-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "terraform-private-subnet-1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "terraform-my-igw"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform-public-rt"
  }
}

resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "terraform-private-rt"
  }
}

resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-route.id
}