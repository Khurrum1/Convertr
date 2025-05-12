# Private VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# variable "subnet_count" {
#   default = 3
# }

resource "aws_subnet" "subnets" {
  count             = var.subnet_count
  vpc_id           = aws_vpc.main.id
  cidr_block       = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  tags = {
   Name = "subnet-${count.index}"
   Environment = "dev"
  }
}

# Route Table 1
resource "aws_route_table" "route_table_1" {
  vpc_id = aws_vpc.main.id
}


# Route Table association
resource "aws_route_table_association" "a" {
  count = var.subnet_count
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.route_table_1.id
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  count = var.subnet_count
  route_table_id  = aws_route_table.route_table_1.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

# Interface endpoint for S3 access
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.eu-west-2.s3"
}
