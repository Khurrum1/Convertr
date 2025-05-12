# Description
A reusable Terraform template for deploying a serverless backend API that receives and stores files.

# Resources created
- AWS Lambda (backend compute)
- API Gateway (HTTP entry point)
- S3 (file storage)
- Private VPC

# Usage
1. Copy terraform.tfvars.example file:
`cp terraform.tfvars.example terraform.tfvars`

2. Customise values in terraform.tfvars as required before applying

3. Update bucket name to reflect your unique bucket name in `lambda-s3-policy.json`


# Testing

The command below sends a POST request of a base64 encoded image to the API Gateway endpoint `/upload`. If all is successful you should see a success message returned and your bucket will contain the object.

Run the curl command below:

```curl
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "filename": "test.png",
    "filedata": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII="
  }' \
  https://<your-api-id>.execute-api.<region>.amazonaws.com/<stage>/upload

```