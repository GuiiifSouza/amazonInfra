output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

output "rds_port" {
  value = module.rds.db_instance_port
}

output "rds_db_name" {
  value = var.rds_db_name
}

output "rds_username" {
  value = var.rds_username
}

output "rds_password" {
  value = var.rds_password
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "cluster_name" {
  value = var.cluster_name
}

output "aws_region" {
  value = var.aws_region
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = var.bucket_name
}

output "url_ghost" {
  description = "The URL of the Ghost blog"
  value       = "http://localhost:8080"
}

