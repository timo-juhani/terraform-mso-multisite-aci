# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: module that defines creating VPC port using MSO.

terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}


################################################################################
# Information Gathering
################################################################################

# Gather information related to the site
data "mso_site" "site" {
  name = var.site_name
}

# Gather information about MSO schema

data "mso_schema" "schema" {
  name = var.schema_name
}

################################################################################
# Create Virtual Portchannel Port
################################################################################

# Create stict port assocation
# NOTE: remember that ACI site must have this access policy first!

resource "mso_schema_site_anp_epg_static_port" "static_port" {
  template_name        = var.template_name
  anp_name             = var.ap
  epg_name             = var.ep
  path_type            = "vpc"
  deployment_immediacy = "immediate"
  pod                  = var.pod
  leaf                 = var.leaf
  path                 = var.path
  vlan                 = var.vlan_id
  mode                 = "regular"
  schema_id            = data.mso_schema.schema.id
  site_id              = data.mso_site.site.id
}
