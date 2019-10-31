# Terraform Module - CloudFront Blue Deployment

Creates Blue ENV of the Blue/Green deployment of CloudFront, including:

- WAF rules to protect blue
- S3 buckets for blue
- CloudFront distribution
- Firehose for WAF logs

## Usage

Example:

```
module "cf_website_de" {
  source = "git::https://github.com/IronCore864/tfm-cf-s3-waf-lambda-blue.git"
  naming_prefix = "xxx"
  acm_certificate_arn       = var.cf_cert_arn
  aliases                   = var.aliases
  origin_request_lambda_arn = "xxx"
  viewer_request_lambda_arn = "xxx"
  routing_rules             = var.routing_rules_blue
  blue_host_name            = var.blue_host_name
  cookie_token              = var.blue_access_cookie
  r53_zone_id               = var.r53_zone_id
  blue_r53_name             = var.blue_r53_name
}
```

