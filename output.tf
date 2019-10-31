output s3_bucket_blue_id {
  value = aws_s3_bucket.blue.id
}

output s3_bucket_blue_arn {
  value = aws_s3_bucket.blue.arn
}

output cf_domain_name {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output cf_hosted_zone_id {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}

output cf_origin_access_identity_iam_arn {
  value = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
}
