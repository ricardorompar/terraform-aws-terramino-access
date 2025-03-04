output "hostname" {
  value = "http://${aws_instance.web.public_ip}"
}

output "ip" {
  value = aws_instance.web.public_ip
}
