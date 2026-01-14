output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecr_url" {
  value = module.ecr.repository_url
}