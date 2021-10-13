# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: a demo Terraform file to that declares a sample ACI Multi-Site
# network.


################################################################################
# Information Gathering
################################################################################

# Gather information related to Site 1
# data "mso_site" "site1" {
#   name = var.site1_name
# }

# Gather information related to Site 2 
data "mso_site" "site2" {
  name = var.site2_name
}

################################################################################
# Tenant Creation
################################################################################

# Create the tenant and assign it to ACI Site 2
resource "mso_tenant" "tenant" {
  name         = var.tenant
  display_name = var.tenant
  description  = "Created by Terraform!"
  site_associations {
    site_id = data.mso_site.site2.id
  }
}

################################################################################
# Multi-Site Schema Creation
################################################################################

# Ceate and attach templates to tenant. 
# One template for intersite shared networking and one for each site to capture
# site specific configurations.

# Create the schema and add intersite template to the schema
resource "mso_schema" "schema" {
  name          = var.schema
  tenant_id     = mso_tenant.tenant.id
  template_name = var.intersite_template
  depends_on    = [mso_tenant.tenant]
}

# Add Site 1 template to the schema
resource "mso_schema_template" "site1_template" {
  schema_id    = mso_schema.schema.id
  tenant_id    = mso_tenant.tenant.id
  name         = var.site1_template
  display_name = var.site1_template
  depends_on   = [mso_schema.schema]
}

# Add Site 2 template to the schema
resource "mso_schema_template" "site2_template" {
  schema_id    = mso_schema.schema.id
  tenant_id    = mso_tenant.tenant.id
  name         = var.site2_template
  display_name = var.site2_template
  depends_on   = [mso_schema.schema]
}

################################################################################
# Intersite Template Configuration
################################################################################

# Create an Application Profile for Intersite network that hosts all EPGs.
resource "mso_schema_template_anp" "ap_intersite" {
  schema_id    = mso_schema.schema.id
  template     = var.intersite_template
  name         = var.ap_intersite
  display_name = var.ap_intersite
  depends_on   = [mso_schema.schema]
}

# Create a single shared VRF to which all BDs connect
resource "mso_schema_template_vrf" "vrf_intersite" {
  schema_id    = mso_schema.schema.id
  template     = var.intersite_template
  name         = var.vrf_intersite
  display_name = var.vrf_intersite
  depends_on   = [mso_schema.schema]
}

# Create a BD and attach to the shared VRF.
resource "mso_schema_template_bd" "bd_intersite" {
  schema_id     = mso_schema.schema.id
  template_name = var.intersite_template
  name          = var.bd_intersite
  display_name  = var.bd_intersite
  vrf_name      = mso_schema_template_vrf.vrf_intersite.name
  depends_on    = [mso_schema_template_vrf.vrf_intersite]
}

# Create EPG per each BD in a network centric deployment model.
resource "mso_schema_template_anp_epg" "epg_intersite" {
  schema_id     = mso_schema.schema.id
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
  schema_id          = mso_schema.schema.id
  template_name      = var.intersite_template
  name               = "permit_any"
  display_name       = "permit_any"
  entry_name         = "permit_any"
  entry_display_name = "permit_any"
  ether_type         = "unspecified"
  depends_on         = [mso_schema.schema]
}

# This contract will be used by Site 1 when accessing gateway sitting in the
# Intersite network.
resource "mso_schema_template_contract" "permit_all_site1" {
  schema_id     = mso_schema.schema.id
  template_name = var.intersite_template
  contract_name = var.c_permit_all_site1
  display_name  = var.c_permit_all_site1
  filter_type   = "bothWay"
  scope         = "context"
  filter_relationships = {
    filter_schema_id     = mso_schema.schema.id
    filter_template_name = var.intersite_template
    filter_name          = mso_schema_template_filter_entry.permit_all.name
  }
  directives = ["none"]
  depends_on = [mso_schema_template_filter_entry.permit_all]
}

# This contract will be used by Site 2 when accessing gateway sitting in the
# Intersite network.
resource "mso_schema_template_contract" "permit_all_site2" {
  schema_id     = mso_schema.schema.id
  template_name = var.intersite_template
  contract_name = var.c_permit_all_site2
  display_name  = var.c_permit_all_site2
  filter_type   = "bothWay"
  scope         = "context"
  filter_relationships = {
    filter_schema_id     = mso_schema.schema.id
    filter_template_name = var.intersite_template
    filter_name          = mso_schema_template_filter_entry.permit_all.name
  }
  directives = ["none"]
  depends_on = [mso_schema_template_filter_entry.permit_all]
}

# Intersite network provides the GW for Site1.
resource "mso_schema_template_anp_epg_contract" "epg_intersite_all_site1" {
  schema_id         = mso_schema.schema.id
  template_name     = var.intersite_template
  anp_name          = mso_schema_template_anp.ap_intersite.name
  epg_name          = mso_schema_template_anp_epg.epg_intersite.name
  contract_name     = mso_schema_template_contract.permit_all_site1.contract_name
  relationship_type = "provider"
  depends_on = [
    mso_schema.schema,
    mso_schema_template_anp_epg.epg_intersite,
    mso_schema_template_contract.permit_all_site1
  ]
}

# Intersite network provides the GW for Site2.
resource "mso_schema_template_anp_epg_contract" "epg_intersite_all_site2" {
  schema_id         = mso_schema.schema.id
  template_name     = var.intersite_template
  anp_name          = mso_schema_template_anp.ap_intersite.name
  epg_name          = mso_schema_template_anp_epg.epg_intersite.name
  contract_name     = mso_schema_template_contract.permit_all_site2.contract_name
  relationship_type = "provider"
  depends_on = [
    mso_schema.schema,
    mso_schema_template_anp_epg.epg_intersite,
    mso_schema_template_contract.permit_all_site2
  ]
}

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

################################################################################
# Attach Schema to Sites
################################################################################

# Add Intersite network to Site 1
#resource "mso_schema_site" "site1_intersite" {
#  schema_id     = mso_schema.schema.id
#  site_id       = data.mso_site.site1.id
#  template_name = var.intersite_template
#  depends_on    = [mso_schema.schema]
#}

# Add Intersite network to Site 2
resource "mso_schema_site" "site2_intersite" {
  schema_id     = mso_schema.schema.id
  site_id       = data.mso_site.site2.id
  template_name = var.intersite_template
  depends_on    = [mso_schema.schema]
}

# Add Site 1 specific network to Site 1
#resource "mso_schema_site" "site_config_site1" {
#  schema_id     = mso_schema.schema.id
#  site_id       = data.mso_site.site1.id
#  template_name = var.site1_template
#  depends_on    = [mso_schema_template.site1_template]
#}

# Add Site 2 specific network to Site 2
resource "mso_schema_site" "site_config_site2" {
  schema_id     = mso_schema.schema.id
  site_id       = data.mso_site.site2.id
  template_name = var.site2_template
  depends_on    = [mso_schema_template.site2_template]
}

################################################################################
# Deploy The Schema to ACI Sites
################################################################################

# Deploy Intersite network configuration to ACI Site 1
#resource "mso_schema_template_deploy" "deploy_intersite_site1" {
#  schema_id     = mso_schema.schema.id
#  template_name = var.intersite_template
#  site_id       = data.mso_site.site1.id
#  undeploy      = false
#}

# Deploy Intersite network configuration to ACI Site 2
resource "mso_schema_template_deploy" "deploy_intersite_site2" {
  schema_id     = mso_schema.schema.id
  template_name = var.intersite_template
  site_id       = data.mso_site.site2.id
  undeploy      = false
}

# Deploy Site 1 specific network configuration to ACI Site 1
#resource "mso_schema_template_deploy" "deploy_site1" {
#  schema_id     = mso_schema.schema.id
#  template_name = var.site1_template
#  site_id       = data.mso_site.site1.id
#  undeploy      = false
#}

# Deploy Site 2 specific network configuration to ACI Site 2
resource "mso_schema_template_deploy" "deploy_site2" {
  schema_id     = mso_schema.schema.id
  template_name = var.site2_template
  site_id       = data.mso_site.site2.id
  undeploy      = false
}
