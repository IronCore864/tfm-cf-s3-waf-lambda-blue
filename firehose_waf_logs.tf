locals {
  # only lowercase alphanumeric characters and hyphens allowed in s3 bucket name
  waf_log_bucket = "${replace(var.naming_prefix, "_", "-")}-waf-log"
}

resource "aws_s3_bucket" "waf_log" {
  bucket = local.waf_log_bucket
  acl    = "private"
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.naming_prefix}_cf_firehose"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

resource "aws_kinesis_firehose_delivery_stream" "stream" {
  provider = aws.us-east-1
  # name must have prefix "aws-waf-logs-"
  # more details check: https://docs.aws.amazon.com/waf/latest/developerguide/logging.html  
  name = "aws-waf-logs-${replace(var.naming_prefix, "_", "-")}-analytics"

  destination = "s3"

  s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.waf_log.arn
  }
}
