# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: a demo Terraform file to that declares a sample ACI Multi-Site
# network.

################################################################################
# Site 1 Template Configuration
################################################################################

# Create an AP for containing Site 1's EPGs
resource "mso_schema_template_anp" "ap_site1" {
  schema_id    = mso_schema.schema.id
  template     = var.site1_template
  name         = var.ap_site1
  display_name = var.ap_site1
  depends_on   = [mso_schema_template.site1_template]
}

# Create a BD for each EPG. Network centric deployment model.
resource "mso_schema_template_bd" "bd_site1" {
  schema_id         = mso_schema.schema.id
  template_name     = var.site1_template
  name              = var.bd_site1
  display_name      = var.bd_site1
  vrf_name          = mso_schema_template_vrf.vrf_intersite.name
  vrf_template_name = var.intersite_template
  depends_on = [
    mso_schema_template.site1_template,
    mso_schema_template_vrf.vrf_intersite
  ]
}

# Create an EPG per VLAN per BD. Network centric deployment model. 
resource "mso_schema_template_anp_epg" "epg_site1" {
  schema_id         = mso_schema.schema.id
  template_name     = var.site1_template
  anp_name          = mso_schema_template_anp.ap_site1.name
  name              = var.epg_site1
  display_name      = var.epg_site1
  bd_name           = mso_schema_template_bd.bd_site1.name
  vrf_name          = mso_schema_template_vrf.vrf_intersite.name
  vrf_template_name = var.intersite_template
  depends_on = [
    mso_schema_template.site1_template,
    mso_schema_template_anp.ap_site1
  ]
}

# Site 1 consumes the the GW functionality sitting in the Intersite network.
resource "mso_schema_template_anp_epg_contract" "epg_site1_all" {
  schema_id              = mso_schema.schema.id
  template_name          = var.site1_template
  anp_name               = mso_schema_template_anp.ap_site1.name
  epg_name               = mso_schema_template_anp_epg.epg_site1.name
  contract_name          = mso_schema_template_contract.permit_all_site1.contract_name
  contract_template_name = var.intersite_template
  relationship_type      = "consumer"
  depends_on = [
    mso_schema.schema,
    mso_schema_template_anp_epg.epg_site1,
    mso_schema_template_contract.permit_all_site1
  ]
}
