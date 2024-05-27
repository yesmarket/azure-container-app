locals {
  ci_name = "${var.naming_prefix}-shir-ci"
  ca_container_name = replace(replace(var.image_name, ":latest", ""), ".", "-")
}
