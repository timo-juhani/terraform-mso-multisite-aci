# MSO crendentials
variable "mso_username" {
  type = string
}
variable "mso_password" {
  type = string
}
variable "mso_url" {
  type = string
}

# Site IDs can be found using the Swagger documentation at MSO
variable "site1_id" {
  default = "5f9ac0371100001703b9d6c0"
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

# Three APs and three EPGs are required for this example tenant
variable "ap_intersite" {
  default = "big-dipper-intersite"
}
variable "ap_site1" {
  default = "big-dipper-site1"
}
variable "ap_site2" {
  default = "big-dipper-site2"
}
variable "epg_intersite" {
  default = "big-dipper-GW"
}
variable "epg_site1" {
  default = "big-dipper-VM-site1"
}
variable "epg_site2" {
  default = "big-dipper-VM-site2"
}

# A single VRF is allocated that connects all BDs
variable "vrf_intersite" {
  default = "big-dipper-intersite"
}

# A BD per EPG is created
variable "bd_intersite" {
  default = "big-dipper-GW"
}
variable "bd_site1" {
  default = "big-dipper-VM-site1"
}
variable "bd_site2" {
  default = "big-dipper-VM-site2"
}

# Contracts are used to allow traffic between EPGs
variable "c_permit_all_site1" {
  default = "permit-all-site1"
}
variable "c_permit_all_site2" {
  default = "permit-all-site2"
}
variable "f_permit_all" {
  default = "permit-all"
}
