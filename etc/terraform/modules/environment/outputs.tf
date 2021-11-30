output "project" {
  value = local.project
}

output "id" {
  description = "Nome identificador do ambiente de execução."
  value = local.selected_environment_id
}

output "config" {
  description = "Configurações do ambiente de execução."
  value = local.environments[local.selected_environment_id]
}

output "common_base_name" {
  value = local.common_base_name
}

output "common_base_path" {
  value = local.common_base_path
}
