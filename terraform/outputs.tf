# outputs.tf

output "bastion_public_ip" {
  description = "SSH into this to access private instances"
  value       = aws_instance.bastion.public_ip
}

output "app_server_private_ip" {
  description = "App server IP (accessible via bastion only)"
  value       = aws_instance.app_server.private_ip
}

output "alb_dns_name" {
  description = "Public URL to access the application"
  value       = aws_lb.main.dns_name
}

output "rds_endpoint" {
  description = "Database endpoint for app connection"
  value       = aws_db_instance.postgres.endpoint
}