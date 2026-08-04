# terraform init
# terraform plan
# terraform apply (plan & apply)
# terraform destroy (destroy the resources)

###  AWS provider  #######################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
# after adding aws provider need run "terraform init" to download all plugins / laibrories we will use

provider "aws" {
  region     = "us-east-1"
  # access_key = "access_key"
  # secret_key = "secret_key"
}

###  Virtual Private Cloud (VPC)  ########################################

resource "aws_vpc" "vpc_param" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-spi-terraform"
  }
}

# output "vpc_id" {
#     value = aws_vpc.vpc_param
# }

###  Subnets  ############################################################

resource "aws_subnet" "public_subnet_1a_param" {
  vpc_id = aws_vpc.vpc_param.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-snet-spi-terraform-1a"
  }

  depends_on = [aws_vpc.vpc_param]
}

resource "aws_subnet" "public_subnet_1b_param" {
  vpc_id = aws_vpc.vpc_param.id

  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-snet-spi-terraform-1b"
  }

  depends_on = [aws_vpc.vpc_param]
}

resource "aws_subnet" "private_subnet_1c_param" {
  vpc_id = aws_vpc.vpc_param.id

  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private-snet-spi-terraform-1c"
  }

  depends_on = [aws_vpc.vpc_param]
}

### Internet Gateway  ###############################################

resource "aws_internet_gateway" "igw_param" {
  vpc_id = aws_vpc.vpc_param.id

  tags = {
    Name = "igw-spi-terraform"
  }

  depends_on = [aws_vpc.vpc_param]
}

### Elastic IP ######################################################

resource "aws_eip" "eip_param" {
  tags = {
    Name = "eip-spi-terraform"
  }
}

### NAT Gateway #####################################################

resource "aws_nat_gateway" "ngw_param" {
  subnet_id     = aws_subnet.public_subnet_1a_param.id
  allocation_id = aws_eip.eip_param.id

  tags = {
    Name = "ngw-show-private-ip-terraform"
  }

  depends_on = [aws_subnet.public_subnet_1a_param, aws_eip.eip_param]
}

### Route Tables #####################################################

resource "aws_route_table" "public_rt_param" {
  vpc_id = aws_vpc.vpc_param.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_param.id
  }

  tags = {
    Name = "public-rt-spi-terraform"
  }

  depends_on = [aws_vpc.vpc_param, aws_internet_gateway.igw_param]
}

### RT Subnet Association ###

resource "aws_route_table_association" "public_rt_association_1a" {
  subnet_id      = aws_subnet.public_subnet_1a_param.id
  route_table_id = aws_route_table.public_rt_param.id

  depends_on = [aws_subnet.public_subnet_1a_param, aws_route_table.public_rt_param]
}

resource "aws_route_table_association" "public_rt_association_1b" {
  subnet_id      = aws_subnet.public_subnet_1b_param.id
  route_table_id = aws_route_table.public_rt_param.id

  depends_on = [aws_subnet.public_subnet_1b_param, aws_route_table.public_rt_param]
}

### Route Tables #####################################################

resource "aws_route_table" "private_rt_param" {
  vpc_id = aws_vpc.vpc_param.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_param.id
  }

  tags = {
    Name = "private-rt-spi-terraform"
  }

  depends_on = [aws_vpc.vpc_param, aws_nat_gateway.ngw_param]
}

### RT Subnet Association ###

resource "aws_route_table_association" "private_rt_association_1c" {
  subnet_id      = aws_subnet.private_subnet_1c_param.id
  route_table_id = aws_route_table.private_rt_param.id

  depends_on = [aws_subnet.private_subnet_1c_param, aws_route_table.private_rt_param]
}
