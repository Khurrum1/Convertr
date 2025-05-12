# Uncomment and configure this block to enable remote state storage
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "project-name/terraform.tfstate"
#     region         = "us-west-2"
#     dynamodb_table = "terraform-lock-table"
#     encrypt        = true
#   }
# }
