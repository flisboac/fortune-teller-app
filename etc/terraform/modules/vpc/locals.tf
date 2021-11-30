locals {
  vpc = {
    main = {
      security_groups = {
        admin = aws_security_group.main_admin
        web = aws_security_group.main_web
      }
      subnets = {
        public = aws_subnet.main_public
      }
    }
  }
}
