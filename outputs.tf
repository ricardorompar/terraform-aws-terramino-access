output "hostname" {
  value = "http://${aws_instance.web.public_ip}"
}

output "ip" {
  value = aws_instance.web.public_ip
}

output "key_test" {
  value     = data.vault_kv_secret_v2.vault_ca.data["ca_public_key"]
  sensitive = true
}
