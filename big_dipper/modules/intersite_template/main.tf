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
# Intersite Template Configuration
################################################################################

# Create an Application Profile for Intersite network that hosts all EPGs.
resource "mso_schema_template_anp" "ap_intersite" {
  schema_id    = var.schema_id
  template     = var.intersite_template
  name         = var.ap_intersite
  display_name = var.ap_intersite
}

# Create a single shared VRF to which all BDs connect
resource "mso_schema_template_vrf" "vrf_intersite" {
  schema_id    = var.schema_id
  template     = var.intersite_template
  name         = var.vrf_intersite
  display_name = var.vrf_intersite
}

# Create a BD and attach to the shared VRF.
resource "mso_schema_template_bd" "bd_intersite" {
  schema_id     = var.schema_id
  template_name = var.intersite_template
  name          = var.bd_intersite
  display_name  = var.bd_intersite
  vrf_name      = mso_schema_template_vrf.vrf_intersite.name
  depends_on    = [mso_schema_template_vrf.vrf_intersite]
}

# Create EPG per each BD in a network centric deployment model.
resource "mso_schema_template_anp_epg" "epg_intersite" {
  schema_id     = var.schema_id
  template_name = var.intersite_template
  anp_name      = mso_schema_template_anp.ap_intersite.name
  name          = var.epg_intersite
  display_name  = var.epg_intersite
  bd_name       = mso_schema_template_bd.bd_intersite.name
  vrf_name      = mso_schema_template_vrf.vrf_intersite.name
  depends_on    = [mso_schema_template_anp.ap_intersite]
}

# Create two contracts that are used to allow inter-EPG traffic towards GW
resource "mso_schema_template_filter_entry" "permit_all" {
  schema_id          = var.schema_id
  template_name      = var.intersite_template
  name               = "permit_any"
  display_name       = "permit_any"
  entry_name         = "permit_any"
  entry_display_name = "permit_any"
  ether_type         = "unspecified"
}

# This contract will be used by Site 1 when accessing gateway sitting in the
# Intersite network.
resource "mso_schema_template_contract" "permit_all_site1" {
  schema_id     = var.schema_id
  template_name = var.intersite_template
  contract_name = var.c_permit_all_site1
  display_name  = var.c_permit_all_site1
  filter_type   = "bothWay"
  scope         = "context"
  filter_relationships = {
    filter_schema_id     = var.schema_id
    filter_template_name = var.intersite_template
    filter_name          = mso_schema_template_filter_entry.permit_all.name
  }
  directives = ["none"]
  depends_on = [mso_schema_template_filter_entry.permit_all]
}

# This contract will be used by Site 2 when accessing gateway sitting in the
# Intersite network.
resource "mso_schema_template_contract" "permit_all_site2" {
  schema_id     = var.schema_id
  template_name = var.intersite_template
  contract_name = var.c_permit_all_site2
  display_name  = var.c_permit_all_site2
  filter_type   = "bothWay"
  scope         = "context"
  filter_relationships = {
    filter_schema_id     = var.schema_id
    filter_template_name = var.intersite_template
    filter_name          = mso_schema_template_filter_entry.permit_all.name
  }
  directives = ["none"]
  depends_on = [mso_schema_template_filter_entry.permit_all]
}

# Intersite network provides the GW for Site1.
resource "mso_schema_template_anp_epg_contract" "epg_intersite_all_site1" {
  schema_id         = var.schema_id
  template_name     = var.intersite_template
  anp_name          = mso_schema_template_anp.ap_intersite.name
  epg_name          = mso_schema_template_anp_epg.epg_intersite.name
  contract_name     = mso_schema_template_contract.permit_all_site1.contract_name
  relationship_type = "provider"
  depends_on = [
    mso_schema_template_anp_epg.epg_intersite,
    mso_schema_template_contract.permit_all_site1
  ]
}

# Intersite network provides the GW for Site2.
resource "mso_schema_template_anp_epg_contract" "epg_intersite_all_site2" {
  schema_id         = var.schema_id
  template_name     = var.intersite_template
  anp_name          = mso_schema_template_anp.ap_intersite.name
  epg_name          = mso_schema_template_anp_epg.epg_intersite.name
  contract_name     = mso_schema_template_contract.permit_all_site2.contract_name
  relationship_type = "provider"
  depends_on = [
    mso_schema_template_anp_epg.epg_intersite,
    mso_schema_template_contract.permit_all_site2
  ]
}
