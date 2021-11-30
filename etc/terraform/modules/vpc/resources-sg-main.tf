resource "aws_security_group" "main_admin" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${module.environment.common_base_name}-main-admin"
  description = "Habilita conexoes inbound para servicos administrativos (SSH, ICMP, etc)"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.environment.config.aws.default_tags
}

resource "aws_security_group" "main_web" {
  vpc_id = "${aws_vpc.main.id}"
  name = "${module.environment.config.common_base_name}-main-web"
  description = "Habilita conexoes inbound para HTTP e HTTPS"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = module.environment.config.aws.default_tags
}
