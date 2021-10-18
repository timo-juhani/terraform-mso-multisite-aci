# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: module that defines creating access port using MSO.

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
# Create Access Port
################################################################################

# Create domain assocation
# NOTE: remember that ACI site must have this access policy first!

resource "mso_schema_site_anp_epg_domain" "domain" {
  template_name        = var.template_name
  anp_name             = var.ap
  epg_name             = var.ep
  domain_type          = "physicalDomain"
  dn                   = var.domain
  deploy_immediacy     = "immediate"
  resolution_immediacy = "immediate"
  vlan_encap_mode      = "static"
  schema_id            = data.mso_schema.schema.id
  site_id              = data.mso_site.site.id
}
