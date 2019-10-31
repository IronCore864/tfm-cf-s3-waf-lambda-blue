resource "aws_waf_web_acl" "allow_office_ip_de_blue" {
  depends_on = ["aws_waf_byte_match_set.blue_host", "aws_waf_byte_match_set.cookie", "aws_waf_rule.cookie_access_blue"]
  name       = var.naming_prefix
  # Only alphanumeric characters allowed in "metric_name"
  metric_name = "${replace(var.naming_prefix, "_", "")}"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = aws_waf_rule.cookie_access_blue.id
    type     = "REGULAR"
  }

  logging_configuration {
    log_destination = aws_kinesis_firehose_delivery_stream.stream.arn

    redacted_fields {
      field_to_match {
        type = "URI"
      }

      field_to_match {
        data = "referer"
        type = "HEADER"
      }
    }
  }
}
