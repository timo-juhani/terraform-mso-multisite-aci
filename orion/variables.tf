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
  default = "5ee1d973120000f732f3b38f"
}
variable "tenant1" {
  default = "orion"
}
variable "schema1" {
  default = "ms_orion"
}
variable "ap1" {
  default = "ap_orion"
}
variable "epg1" {
  default = "epg_orion_1"
}
variable "epg2" {
  default = "epg_orion_2"
}
variable "vrf1" {
  default = "vrf_orion"
}
variable "bd1" {
  default = "bd_orion"
}
variable "subnet1" {
  default = "10.1.1.1/24"
}
