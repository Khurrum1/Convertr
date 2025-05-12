resource "aws_api_gateway_rest_api" "object_storage_api" {
  name        = "ObjectStorageAPI"
  description = "API Gateway for uploading objects to S3 via Lambda"
}
resource "aws_api_gateway_resource" "object_storage_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.object_storage_api.id
  parent_id   = aws_api_gateway_rest_api.object_storage_api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_method" "object_storage_api_method" {
  rest_api_id   = aws_api_gateway_rest_api.object_storage_api.id
  resource_id   = aws_api_gateway_resource.object_storage_api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "object_storage_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.object_storage_api.id
  resource_id             = aws_api_gateway_resource.object_storage_api_resource.id
  http_method             = aws_api_gateway_method.object_storage_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.object_storage_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "object_storage_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.object_storage_api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.object_storage_api_resource.id,
      aws_api_gateway_method.object_storage_api_method.id,
      aws_api_gateway_integration.object_storage_api_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "object_storage_api_stage" {
  deployment_id = aws_api_gateway_deployment.object_storage_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.object_storage_api.id
  stage_name    = "prod"
}