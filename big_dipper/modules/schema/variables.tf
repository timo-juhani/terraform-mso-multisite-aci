# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Variable definitions for MSO schema.
  
# variable "site1_name" {
#   type        = string
#   description = "Name of the ACI Site 1"
# }

variable "site2_name" {
  type        = string
  description = "Name of the ACI Site 2"
}

variable "tenant" {
  type        = string
  description = "Name of the multi-site tenant"
}

variable "schema" {
  type        = string
  description = "Name of the multi-site schema"
}

variable "intersite_template" {
  type        = string
  description = "Name of the Intersite network template"
}

variable "site1_template" {
  type        = string
  description = "Name of the Site 1 network template"
}

variable "site2_template" {
  type        = string
  description = "Name of the Site 2 network template"
}
