import json
import boto3
import base64
import os
import mimetypes

# Initialize the S3 client
s3 = boto3.client("s3")

# Get the S3 bucket name from environment variables
BUCKET_NAME = os.environ["BUCKET_NAME"]

def lambda_handler(event, context):
    try:
        # Parse the incoming JSON body
        body = json.loads(event["body"])

        filename = body["filename"]       # e.g. "image.jpg"
        filedata = body["filedata"]       # base64-encoded image content

        # Decode base64 string into bytes
        image_bytes = base64.b64decode(filedata)

        # Guess the MIME type (e.g., "image/jpeg") based on the file extension
        content_type, _ = mimetypes.guess_type(filename)
        if content_type is None:
            content_type = "application/octet-stream"  # fallback if type unknown

        # Upload the image to S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=filename,
            Body=image_bytes,
            ContentType=content_type
        )

        # Return success response
        return {
            "statusCode": 200,
            "body": json.dumps(f"File '{filename}' uploaded successfully to {BUCKET_NAME}")
        }

    except Exception as e:
        # Return error response if something goes wrong
        return {
            "statusCode": 500,
            "body": json.dumps(f"Error: {str(e)}")
        }