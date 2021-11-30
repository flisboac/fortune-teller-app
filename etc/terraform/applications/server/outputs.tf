output "app_urls" {
  value = values({
    for instance in aws_instance.main_public: instance.id => "https://${instance.public_dns}"
    if instance.associate_public_ip_address
  })
}

output "app_hostnames" {
  value = values({
    for instance in aws_instance.main_public: instance.id => instance.public_dns
    if instance.associate_public_ip_address
  })
}

output "app_ips" {
  value = values({
    for instance in aws_instance.main_public: instance.id => instance.public_ip
    if instance.associate_public_ip_address
  })
}
