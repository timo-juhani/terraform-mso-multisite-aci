# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Variable definitions for MSO Intersite template.

variable "intersite_template" {
  type        = string
  description = "The name of the Intersite template"
}

variable "ap_intersite" {
  type        = string
  description = "The name of the Intersite Application Profile"
}

variable "epg_intersite" {
  type        = string
  description = "The name of the Intersite EPG"
}

variable "vrf_intersite" {
  type        = string
  description = "The name of the Intersite VRF"
}

variable "bd_intersite" {
  type        = string
  description = "The name of the Intersite Bridge Domain"
}

variable "c_permit_all_site1" {
  type        = string
  description = "The name of the Site 1 Intersite permit all contract"
}

variable "c_permit_all_site2" {
  type        = string
  description = "The name of the Site 2 Intersite permit all contract"
}

variable "f_permit_all" {
  type        = string
  description = "The name of the permit all traffic filter"
}

variable "schema_id" {
  type        = string
  description = "The ID of the MSO schema"
}
