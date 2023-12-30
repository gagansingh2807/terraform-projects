# Nategateway.tf - Final Version

# VPC Declaration
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16" # Update with your VPC CIDR block

  tags = {
    Name = "MainVPC"
  }
}

# Internet Gateway Declaration
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MainInternetGateway"
  }
}

# Public Subnet AZ1 Declaration
resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Updated to match the us-east-1 region

  tags = {
    Name = "PublicSubnetAZ1"
  }
}

# Public Subnet AZ2 Declaration
resource "aws_subnet" "public_subnet_az2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Updated to match the us-east-1 region

  tags = {
    Name = "PublicSubnetAZ2"
  }
}

# Elastic IP for NAT Gateway AZ1
resource "aws_eip" "eip_for_nat_gateway_az1" {
  domain = "vpc"

  tags = {
    Name = "nat gateway az1 eip"
  }
}

# Elastic IP for NAT Gateway AZ2
resource "aws_eip" "eip_for_nat_gateway_az2" {
  domain = "vpc"

  tags = {
    Name = "nat gateway az2 eip"
  }
}

# NAT Gateway in Public Subnet AZ1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = "nat gateway az1"
  }

  depends_on = [aws_internet_gateway.main_internet_gateway]
}

# NAT Gateway in Public Subnet AZ2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags = {
    Name = "nat gateway az2"
  }

  depends_on = [aws_internet_gateway.main_internet_gateway]
}
