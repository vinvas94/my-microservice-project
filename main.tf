terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "default"
}

# --- Backend S3 + DynamoDB ---
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-vinvas-eu"
  table_name  = "terraform-locks"
}

# --- VPC ---
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_name           = "lesson-5-vpc"
}

# --- ECR ---
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-7-ecr"
  scan_on_push = true
}

# --- EKS ---
module "eks" {
  source        = "./modules/eks"
  cluster_name  = "eks-cluster-hw7"
  subnet_ids    = module.vpc.public_subnets
  instance_type = "t2.medium"
  desired_size  = 1
  max_size      = 2
  min_size      = 1
}

# --- EKS Data Sources ---
data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}

# --- HELM Provider ---
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

# --- Jenkins ---
module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name

  providers = {
    helm = helm
  }
}

# --- RDS con Aurora ---
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = true
  aurora_instance_count      = 2

  # --- Aurora ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"

  # --- Comunes ---
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "root"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections            = "200"
    log_min_duration_statement = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
