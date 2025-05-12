locals {
  # Shared tagging across all resources
  common_tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }

  lambda_tags = {
    Function    = var.lambda_function_name
    Environment = var.environment
  }

  api_gateway_tags = {
    Service     = "ObjectStorageAPI"
    Environment = var.environment
  }

  networking_tags = {
    Component   = "Networking"
    Environment = var.environment
  }

  # Optional: S3 object key prefix
  s3_prefix = "${var.environment}/uploads/"
}
