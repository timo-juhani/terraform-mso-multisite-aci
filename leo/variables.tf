# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Variable definitions for MSO login. Actual values as stored as env variables.

variable "mso_url" {
  type        = string
  description = "The URL of ACI MSO"
}

variable "mso_username" {
  type        = string
  description = "Username of the MSO admin user"
}

variable "mso_password" {
  type        = string
  description = "Password of the MSO admin user"
}
