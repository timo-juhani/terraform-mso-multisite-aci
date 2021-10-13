variable "mso_username" {
  type = string
}
variable "mso_password" {
  type = string
}
variable "mso_url" {
  type = string
}
variable "site1_id" {
  default = "615d40661100004f2ae66787"
}
variable "tenant1" {
  default = "orion"
}
variable "schema1" {
  default = "ms-orion"
}
variable "ap1" {
  default = "ap-orion"
}
variable "epg1" {
  default = "epg-orion_1"
}
variable "epg2" {
  default = "epg-orion_2"
}
variable "vrf1" {
  default = "vrf-orion"
}
variable "bd1" {
  default = "bd-orion"
}
variable "subnet1" {
  default = "10.1.1.1/24"
}
