# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: a demo Terraform file to that declares a sample ACI Multi-Site
# network.


################################################################################
# Site 2 Template Configuration
################################################################################

# Create an AP for containing Site 2's EPGs
resource "mso_schema_template_anp" "ap_site2" {
  schema_id    = mso_schema.schema.id
  template     = var.site2_template
  name         = var.ap_site2
  display_name = var.ap_site2
  depends_on   = [mso_schema_template.site2_template]
}

# Create a BD for each EPG. Network centric deployment model.
resource "mso_schema_template_bd" "bd_site2" {
  schema_id         = mso_schema.schema.id
  template_name     = var.site2_template
  name              = var.bd_site2
  display_name      = var.bd_site2
  vrf_name          = mso_schema_template_vrf.vrf_intersite.name
  vrf_template_name = var.intersite_template
  depends_on = [
    mso_schema_template.site2_template,
    mso_schema_template_vrf.vrf_intersite
  ]
}

# Create an EPG per VLAN per BD. Network centric deployment model. 
resource "mso_schema_template_anp_epg" "epg_site2" {
  schema_id         = mso_schema.schema.id
  template_name     = var.site2_template
  anp_name          = mso_schema_template_anp.ap_site2.name
  name              = var.epg_site2
  display_name      = var.epg_site2
  bd_name           = mso_schema_template_bd.bd_site2.name
  vrf_name          = mso_schema_template_vrf.vrf_intersite.name
  vrf_template_name = var.intersite_template
  depends_on = [
    mso_schema_template.site2_template,
    mso_schema_template_anp.ap_site2
  ]
}

# Site 2 consumes the the GW functionality sitting in the Intersite network.
resource "mso_schema_template_anp_epg_contract" "epg_site2_all" {
  schema_id              = mso_schema.schema.id
  template_name          = var.site2_template
  anp_name               = mso_schema_template_anp.ap_site2.name
  epg_name               = mso_schema_template_anp_epg.epg_site2.name
  contract_name          = mso_schema_template_contract.permit_all_site2.contract_name
  contract_template_name = var.intersite_template
  relationship_type      = "consumer"
  depends_on = [
    mso_schema.schema,
    mso_schema_template_anp_epg.epg_site2,
    mso_schema_template_contract.permit_all_site2
  ]
}
