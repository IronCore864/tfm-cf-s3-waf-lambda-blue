variable naming_prefix {
  type = string
}

variable aliases {
  type = list(string)
}

variable acm_certificate_arn {
  type = string
}

variable origin_request_lambda_arn {
  type = string
}

variable viewer_request_lambda_arn {
  type = string
}

variable cookie_token {
  type = string
}

variable blue_host_name {
  type = string
}

variable r53_zone_id {
  type = string
}

variable blue_r53_name {
  type = string
}

variable routing_rules {
  type = string
}
