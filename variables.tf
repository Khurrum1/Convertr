# variable "vpc_cidr" {
#   default = "10.0.0.0/16"
# }

# variable "availability_zones" {
#   type        = list(string)
#   description = "List of availability zones to use"
#   default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
# }

# variable "region" {
#   default = "eu-west-2"
# }

variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}
