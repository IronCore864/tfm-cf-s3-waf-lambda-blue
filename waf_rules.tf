resource "aws_waf_rule" "cookie_access_blue" {
  depends_on = ["aws_waf_byte_match_set.blue_host", "aws_waf_byte_match_set.cookie"]
  name       = "${var.naming_prefix}_cookie_access_blue"
  # Only alphanumeric characters allowed in "metric_name"
  metric_name = "${replace(var.naming_prefix, "_", "")}cookie"

  predicates {
    data_id = aws_waf_byte_match_set.blue_host.id
    negated = false
    type    = "ByteMatch"
  }

  predicates {
    data_id = aws_waf_byte_match_set.cookie.id
    negated = true
    type    = "ByteMatch"
  }
}
