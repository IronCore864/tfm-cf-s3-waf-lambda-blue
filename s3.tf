locals {
  # only lowercase alphanumeric characters and hyphens allowed in s3 bucket name
  log_bucket = "${replace(var.naming_prefix, "_", "-")}-log"
}

resource "aws_s3_bucket" "blue" {
  bucket        = local.blue_s3_origin_bucket
  acl           = "private"
  force_destroy = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.blue.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.blue.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "blue" {
  bucket = aws_s3_bucket.blue.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket" "log" {
  bucket        = local.log_bucket
  force_destroy = true
}
