resource "aws_waf_byte_match_set" "blue_host" {
  name = "${var.naming_prefix}_blue_host"

  byte_match_tuples {
    text_transformation   = "NONE"
    target_string         = var.blue_host_name
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "HEADER"
      data = "host"
    }
  }
}

resource "aws_waf_byte_match_set" "cookie" {
  name = "${var.naming_prefix}_cookie"

  byte_match_tuples {
    text_transformation   = "NONE"
    target_string         = var.cookie_token
    positional_constraint = "CONTAINS"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }
}
