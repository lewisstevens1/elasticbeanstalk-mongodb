resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = format("%s-%s", var.resource_prefix, var.environment)
  }
}

resource "aws_subnet" "public_subnets" {
  count = var.number_of_azs

  vpc_id = aws_vpc.this.id

  cidr_block = cidrsubnet(
    var.cidr_block,
    var.number_of_azs,
    count.index
  )

  availability_zone = try(data.aws_availability_zones.available.names[count.index], data.aws_availability_zones.available.names[0])

  tags = {
    Name = format(
      "%s-%s-public-az%d",
      var.resource_prefix,
      var.environment,
      count.index + 1,
    )
  }
}

resource "aws_subnet" "private_subnets" {
  count = var.number_of_azs

  vpc_id = aws_vpc.this.id

  cidr_block = cidrsubnet(
    var.cidr_block,
    var.number_of_azs,
    length(aws_subnet.public_subnets) + count.index
  )

  availability_zone = try(data.aws_availability_zones.available.names[count.index], data.aws_availability_zones.available.names[0])

  tags = {
    Name = format(
      "%s-%s-private-az%d",
      var.resource_prefix,
      var.environment,
      count.index + 1,
    )
  }
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_subnets[0].id

  depends_on = [
    aws_internet_gateway.this
  ]
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = toset(aws_subnet.public_subnets[*].id)

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private" {
  for_each = toset(aws_subnet.private_subnets[*].id)

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}
