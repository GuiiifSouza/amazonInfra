variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# VPC
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "nat_gateway_name" {
  description = "Name of the NAT gateway"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
}

variable "public_subnet_names" {
  description = "Name for public subnet"
  type        = string
}

variable "private_subnet_names" {
  description = "Name for private subnet"
  type        = string
}

# EC2
variable "ec2_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "ec2_ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

# EKS
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Version of Kubernetes to use for the EKS cluster"
  type        = string
}

variable "node_instance_type" {
  description = "Instance type for the EKS worker nodes"
  type        = string
}

# RDS
variable "rds_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "Password for the RDS instance"
  type        = string
}

variable "rds_name" {
  description = "Name of the RDS instance"
  type        = string
}

variable "rds_engine" {
  description = "RDS engine type"
  type        = string
}

variable "rds_instance_class" {
  description = "Instance class for RDS"
  type        = string
}

variable "rds_db_name" {
  description = "Name of the RDS database"
  type        = string
}

variable "major_engine_version" {
  description = "The major version of the database engine."
  type        = string
}

variable "family" {
  description = "The family of the DB parameter group."
  type        = string
}

variable "rds_allocated_storage" {
  description = "The amount of storage (in gigabytes) to allocate for the DB instance."
  type        = number
}

# CDN
variable "cdn_name" {
  description = "Name of the CDN"
  type        = string
}

variable "origin_id" {
  description = "Origin ID for the CDN"
  type        = string
}

# S3
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm"
  type        = string
  default     = "AES256"
}

# Ghost
variable "url_ghost" {
  description = "URL for the Ghost blog"
  type        = string
  default     = "http://localhost:8080"
}

