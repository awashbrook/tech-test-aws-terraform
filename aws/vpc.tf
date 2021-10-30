locals {
  preparedTags = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "tech-test"
    Version     = "0.1.0"
    Name        = "${var.candidate}"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = local.preparedTags
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = local.preparedTags
}

resource "aws_subnet" "public" {
  count = 3

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = format("10.150.%d.0/27", count.index) # Need to be able to hold maximum 11 instances
  availability_zone = data.aws_availability_zones.available.names[count.index]
  # map_public_ip_on_launch = "true"
  tags = local.preparedTags
}

resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = local.preparedTags
}

# route associations public
resource "aws_route_table_association" "main-public-1-a" {
  count = 3

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.main-public.id
}

