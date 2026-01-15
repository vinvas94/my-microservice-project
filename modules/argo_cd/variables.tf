variable "name" {
  description = "Helm-relise name"
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "K8s namespace for Argo CD"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Argo CD chart version"
  type        = string
  default     = "5.46.4" 
}

variable "cluster_name" {
  description = "EKS-claster name for connection Helm"
  type        = string
}

variable "oidc_provider_arn" {
  description = "Provider's arn for IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "Provider's url for IRSA"
  type        = string
}