# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: a demo Terraform file to that declares a sample ACI Multi-Site
# network.

terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}

################################################################################
# Site 1 Template Configuration
################################################################################

# Create an AP for containing Site 1's EPGs
resource "mso_schema_template_anp" "ap" {
  schema_id    = var.schema_id
  template     = var.template
  name         = var.ap
  display_name = var.ap
}

# Create a BD for each EPG. Network centric deployment model.
resource "mso_schema_template_bd" "bd" {
  schema_id         = var.schema_id
  template_name     = var.template
  name              = var.bd
  display_name      = var.bd
  vrf_name          = var.intersite_vrf
  vrf_template_name = var.intersite_template
}

# Create an EPG per VLAN per BD. Network centric deployment model. 
resource "mso_schema_template_anp_epg" "epg" {
  schema_id         = var.schema_id
  template_name     = var.template
  anp_name          = mso_schema_template_anp.ap.name
  name              = var.epg
  display_name      = var.epg
  bd_name           = mso_schema_template_bd.bd.name
  vrf_name          = var.intersite_vrf
  vrf_template_name = var.intersite_template
}

# Site 1 consumes the the GW functionality sitting in the Intersite network.
resource "mso_schema_template_anp_epg_contract" "epg_all" {
  schema_id              = var.schema_id
  template_name          = var.template
  anp_name               = mso_schema_template_anp.ap.name
  epg_name               = mso_schema_template_anp_epg.epg.name
  contract_name          = var.site_contract
  contract_template_name = var.intersite_template
  relationship_type      = "consumer"
}
