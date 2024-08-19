provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = var.availability_zones
  public_subnets   = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs
  database_subnets = var.database_subnet_cidrs

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true

  tags = {
    Name = var.vpc_name
  }

  public_subnet_tags = {
    Name = var.public_subnet_names
  }

  private_subnet_tags = {
    Name = var.private_subnet_names
  }

  database_subnet_tags = {
    Name = "${var.private_subnet_names}-database"
  }

  igw_tags = {
    Name = var.nat_gateway_name
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = var.node_instance_type

      tags = {
        Name = var.cluster_name
      }

      additional_security_group_ids = [module.vpc.default_security_group_id]
    }
  }

  manage_aws_auth = false
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.6.0"

  identifier        = var.rds_name
  engine            = var.rds_engine
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  db_name           = var.rds_db_name
  username          = var.rds_username
  password          = var.rds_password

  engine_version       = var.major_engine_version
  family               = var.family
  major_engine_version = var.major_engine_version

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids             = module.vpc.private_subnets
  db_subnet_group_name   = module.vpc.database_subnet_group_name

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = var.rds_name
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.0.0"

  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  name                   = var.ec2_name

  associate_public_ip_address = true

  tags = {
    Name = var.ec2_name
  }
}

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "2.8.0"

  default_cache_behavior = {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.origin_id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values = {
      query_string = false
      cookies = {
        forward = "none"
      }
    }
  }

  origin = [
    {
      domain_name = module.ec2.public_dns
      origin_id   = var.origin_id

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  ]

  price_class = "PriceClass_100"

  geo_restriction = {
    restriction_type = "none"
  }

  viewer_certificate = {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = var.cdn_name
  }
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = var.bucket_name

  versioning = {
    enabled = var.versioning_enabled
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  tags = {
    Name = var.bucket_name
  }
}

