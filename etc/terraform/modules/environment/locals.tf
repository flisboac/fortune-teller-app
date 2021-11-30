locals {
  project_name = "fortune-teller"
  project_root_dir = "${path.module}/../../../.."
  selected_environment_id = terraform.workspace
  common_ami_id = data.aws_ami.ubuntu.id

  aws_region = "us-east-1"
  aws_availability_zones = ["${local.aws_region}a"]
  ssh_key_name = "${local.project_name}-deployer"
  common_base_name = "${local.selected_environment_id}-${local.project_name}"
  common_base_path = "${local.selected_environment_id}/${local.project_name}"

  project = {
    name = local.project_name
    root_dir = local.project_root_dir
  }

  common_env = {
    common_base_name = local.common_base_name
    common_base_path = local.common_base_path

    # Configurações comuns da AWS
    aws = {
      region = local.aws_region
      availability_zones = local.aws_availability_zones

      default_tags = {
        project_name = local.project_name
        app_env = local.selected_environment_id
      }
    }

    # Configurações para instâncias do EC2, separadas por categoria
    ec2 = {
      ssh_base_key_name = local.ssh_key_name

      # Categoria "comum", máquina de uso geral usada para executar os apps (webapps, APIs, etc)
      common = {
        ami_id = local.common_ami_id
        instance_type = "t2.micro"
      }
    }

    vpc = {
      main = {
        cidr = "10.0.0.0/16"
        public_cidr = "10.0.1.0/24"
      }
    }
  }

  environments = {
    dev = merge(local.common_env, {
      id = "dev"
      name = "Desenvolvimento/Testes"
    })

    stg = merge(local.common_env, {
      id = "stg"
      name = "Homologação"
    })

    prd = merge(local.common_env, {
      id = "prd"
      name = "Produção"
    })
  }
}
