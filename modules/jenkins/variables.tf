variable "cluster_name" {
  description = "EKS-cluster name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN EKS OIDC providers for IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL EKS OIDC providers"
  type        = string
}