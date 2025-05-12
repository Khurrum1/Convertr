data "archive_file" "lambda_function_payload" {
  type        = "zip"
  source_file = "${path.module}/lambda_src/lambda.py"
  output_path = "${path.module}/lambda_src/object_storage_lambda_v1.zip"
}

resource "aws_lambda_function" "object_storage_lambda" {
  function_name = "object_storage_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.lambda_handler"
  source_code_hash = data.archive_file.lambda_function_payload.output_base64sha256
  filename      = data.archive_file.lambda_function_payload.output_path
  runtime = "python3.12"

  environment {
  variables = {
    BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
  }
}

}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowObjectStorageAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.object_storage_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.object_storage_api.execution_arn}/*"
}

