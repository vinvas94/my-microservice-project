# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-vinvas-eu"
#     key            = "eks/terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }