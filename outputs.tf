output "hostname" {
  value = "http://${aws_instance.web.public_ip}"
}

output "ip" {
  value = aws_instance.web.public_ip
}

output "boundary_connect_alias" {
  value = boundary_alias.ssh.value
}

output "boundary_connect_target_id" {
  value = "boundary connect ssh -target-id ${boundary_target.ssh.id}"
}