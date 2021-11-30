resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = merge(module.environment.config.aws.default_tags, {
    Name = "${module.environment.common_base_name}-main"
  })
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = merge(module.environment.config.aws.default_tags, {
    Name = "${module.environment.common_base_name}-main"
  })
}

resource "aws_route_table_association" "main_public" {
  for_each = aws_subnet.main_public
  subnet_id = each.value.id
  route_table_id = "${aws_route_table.main.id}"
}
