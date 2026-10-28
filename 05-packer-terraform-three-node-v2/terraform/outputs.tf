output "frontend_url" {
  value = "http://${aws_instance.nginx.public_ip}"
}

output "python_backend" {
  value = "http://${aws_instance.python.public_ip}:8080"
}

output "java_backend" {
  value = "http://${aws_instance.java.public_ip}:9090"
}