# Таблиця DynamoDB створена вручну через AWS CLI відповідно до вимог завдання,
# тому цей ресурс закоментовано, щоб уникнути дублювання або конфлікту.

# resource "aws_dynamodb_table" "terraform_locks" {
#   name           = var.table_name
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"
#
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#
#   tags = {
#     Name = "Terraform Lock Table"
#   }
# }
