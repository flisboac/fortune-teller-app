resource "aws_vpc" "main" {
  cidr_block = "${module.environment.config.vpc.main.cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(module.environment.config.aws.default_tags, {
    Name = "${module.environment.common_base_name}-main"
  })
}

resource "aws_subnet" "main_public" {
  for_each = toset(module.environment.config.aws.availability_zones)

  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${module.environment.config.vpc.main.public_cidr}"
  availability_zone = "${each.key}"
  tags = module.environment.config.aws.default_tags
}
