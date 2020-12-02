provider "mso" {
  username = var.mso_username
  password = var.mso_password
  url      = var.mso_url
  insecure = true
}
