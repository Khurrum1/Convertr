resource "aws_iam_role" "lambda_role" {
  name               = "iam_for_lambda"
  assume_role_policy = file("trust-policies/trust-policy-lambda.json")
}


resource "aws_iam_policy" "lambda_s3_policy" {
  name        = "lambda-s3-write-policy"
  description = "Allows Lambda to write to S3 and log to CloudWatch"
  policy      = file("policies/lambda-s3-policy.json")
}


resource "aws_iam_policy_attachment" "lambda_role_attachment" {
  name       = "lamda-role-attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}
