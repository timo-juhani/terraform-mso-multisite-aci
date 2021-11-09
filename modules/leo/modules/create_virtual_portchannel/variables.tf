# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Ouput definitions for create_access_port.

variable "site_name" {
  type        = string
  description = "The name of the site."
}

variable "schema_name" {
  type        = string
  description = "The name of the schema."
}

variable "template_name" {
  type        = string
  description = "The name of the template."
}

variable "ap" {
  type        = string
  description = "The name of the Application Profile."
}

variable "ep" {
  type        = string
  description = "The name of the EPG."
}
variable "pod" {
  type        = string
  description = "The POD name."
}

variable "leaf" {
  type        = string
  description = "The name of leaf."
}

variable "path" {
  type        = string
  description = "The selector path."
}

variable "vlan_id" {
  type        = string
  description = "The VLAN ID."
}
