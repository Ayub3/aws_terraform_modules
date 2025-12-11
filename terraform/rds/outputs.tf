output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.rds.endpoint
}

output "rds_identifier" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.rds.id
}