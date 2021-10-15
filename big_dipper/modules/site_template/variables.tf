# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Variable definitions for MSO Site template.

variable "schema_id" {
  type        = string
  description = "The ID of the MSO schema"
}

variable "template" {
  type        = string
  description = "The name of the site template"
}

variable "ap" {
  type        = string
  description = "The name of Application Profile"
}

variable "epg" {
  type        = string
  description = "The name of EPG"
}

variable "bd" {
  type        = string
  description = "The name of Bridge Domain"
}

variable "intersite_vrf" {
  type        = string
  description = "The name of Intersite VRF"
}

variable "intersite_template" {
  type        = string
  description = "The name of Intersite template"
}

variable "site_contract" {
  type        = string
  description = "The name of the site contract"
}
