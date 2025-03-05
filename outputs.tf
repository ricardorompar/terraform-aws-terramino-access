output "hostname" {
  value = "http://${aws_instance.web.public_ip}"
}

output "ip" {
  value = aws_instance.web.public_ip
}

output "boundary_connect" {
  value = "boundary connect evolutio.ssh.terramino"
}
