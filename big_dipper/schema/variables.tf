
variable "mso_username" {
  default = "admin"
}
variable "mso_password" {
  default = "SanFran1234!"
}
variable "mso_url" {
  default = "https://10.1.106.38/"
}

variable "site1_name" {
  default = "acisim-site1"
}

variable "site2_name" {
  default = "acisim-site2"
}

# One tenant to map all application components in the same place
variable "tenant" {
  default = "big-dipper"
}
# Single schema that consists site specific and intersite objects
variable "schema" {
  default = "ms-big-dipper"
}
variable "intersite_template" {
  default = "big-dipper-intersite"
}
variable "site1_template" {
  default = "big-dipper-site1"
}
variable "site2_template" {
  default = "big-dipper-site2"
}
