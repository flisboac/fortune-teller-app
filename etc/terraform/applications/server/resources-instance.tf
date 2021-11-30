module "keypair" {
  source = "mitchellh/dynamic-keys/aws"
  version = "2.0.0"
  name = "${module.environment.config.ec2.ssh_base_key_name}-main_public"
  path   = "${module.environment.project.root_dir}/local/${module.environment.id}/keys/main-public"
}

resource "aws_instance" "main_public" {
  for_each = module.vpc.main.subnets.public

  instance_type = "${module.environment.config.ec2.common.instance_type}"
  ami = "${module.environment.config.ec2.common.ami_id}"
  subnet_id = "${each.value.id}"
  key_name = "${module.keypair.key_name}"
  associate_public_ip_address = true

  tags = merge(module.environment.config.aws.default_tags, {
    Name = "${module.environment.common_base_name}-main-public"
  })
  
  vpc_security_group_ids = [
    "${module.vpc.main.security_groups.admin.id}",
    "${module.vpc.main.security_groups.web.id}",
  ]

  user_data = <<-EOF
#!/bin/sh
mkdir -p \
  /tmp/app \
  /tmp/app/files \
  /tmp/app/src \
  /tmp/app/ssl
chmod -R a+rwx /tmp/app
EOF

  connection {
    type = "ssh"
    host = self.public_ip
    agent = false
    user = "ubuntu"
    private_key = module.keypair.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/app",
      "mkdir -p /tmp/app/files",
      "mkdir -p /tmp/app/src/api",
      "mkdir -p /tmp/app/src/public",
      "mkdir -p /tmp/app/ssl",
      "chmod -R a+rwx /tmp/app",
    ]
  }

  provisioner "file" {
    source = "${path.module}/instance/files/api.service"
    destination = "/tmp/app/files/systemd.service"
  }

  provisioner "file" {
    source = "${path.module}/instance/files/api.nginx.conf"
    destination = "/tmp/app/files/nginx.conf"
  }

  provisioner "file" {
    source = "${module.environment.project.root_dir}/packages/fortune-teller-api/package.json"
    destination = "/tmp/app/src/api/package.json"
  }

  provisioner "file" {
    source = "${module.environment.project.root_dir}/packages/fortune-teller-api/package-lock.json"
    destination = "/tmp/app/src/api/package-lock.json"
  }

  provisioner "file" {
    source = "${module.environment.project.root_dir}/packages/fortune-teller-api/index.js"
    destination = "/tmp/app/src/api/index.js"
  }

  provisioner "file" {
    source = "${module.environment.project.root_dir}/packages/fortune-teller-webapp/"
    destination = "/tmp/app/src/public/"
  }

  provisioner "file" {
    content = tls_self_signed_cert.ca.cert_pem
    destination = "/tmp/app/ssl/app.pem"
  }

  provisioner "file" {
    content = tls_private_key.ca.private_key_pem
    destination = "/tmp/app/ssl/app.key"
  }

  provisioner "remote-exec" {
    script = "${path.module}/instance/provision.sh"
  }
}
