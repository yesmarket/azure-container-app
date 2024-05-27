locals {
  ca_name = "${var.naming_prefix}-gpg-ca"
  cae_name = "${var.naming_prefix}-gpg-cae"
  ca_container_name = replace(replace(var.image_name, ":latest", ""), ".", "-")
  ca_secret_name = "${replace(var.acr_server, ".", "-")}-pass"
}
