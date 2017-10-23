# hits counter config, change it to meet your needs

Rails.application.config.hc_username = "user"
Rails.application.config.hc_password = "pass"
Rails.application.config.hc_config = {
  "exact" => ["/", "/a"],
  "regex" => ["/a*"]
}
