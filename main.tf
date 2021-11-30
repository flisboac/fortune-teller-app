terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.67"
    }
  }

  # TODO Estratégia de armazenamento do tfstate no S3 (stack separada?)
  # backend "s3" {
  #   bucket = "flisboac-terraform-deployments"
  #   key = "terraform.tfstate"
  #   encrypt = true
  #   dynamodb_table = "terraform-deployments"
  # }
}

module "server" {
  source = "./etc/terraform/applications/server"
}

output "app_urls" {
  value = "${module.server.app_urls}"
}

output "app_hostnames" {
  value = "${module.server.app_hostnames}"
}

output "app_ips" {
  value = "${module.server.app_ips}"
}
