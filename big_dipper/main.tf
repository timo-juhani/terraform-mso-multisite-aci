# Remember to run Terraform with a tag -parallelism=1

# Create single tenant to host all application components
resource "mso_tenant" "tenant" {
  name         = var.tenant
  display_name = var.tenant
  description  = "Created by Terraform!"
  site_associations {
    site_id = var.site1_id
  }
}

# Attach templates to tenant. One template for intersite objects and one for each site.
resource "mso_schema" "schema" {
  name          = var.schema
  tenant_id     = mso_tenant.tenant.id
  template_name = var.intersite_template
}

resource "mso_schema_template" "site1_template" {
  schema_id    = mso_schema.schema.id
  tenant_id    = mso_tenant.tenant.id
  name         = var.site1_template
  display_name = var.site1_template
}

resource "mso_schema_template" "site2_template" {
  schema_id    = mso_schema.schema.id
  tenant_id    = mso_tenant.tenant.id
  name         = var.site2_template
  display_name = var.site2_template
}

# Attach Schema to sites
resource "mso_schema_site" "schema_to_intersite" {
  schema_id     = mso_schema.schema.id
  site_id       = var.site1_id
  template_name = var.intersite_template
}

resource "mso_schema_site" "schema_to_site1" {
  schema_id     = mso_schema.schema.id
  site_id       = var.site1_id
  template_name = var.site1_template
}

# Create aplication profiles for templates.
resource "mso_schema_template_anp" "ap_intersite" {
  schema_id    = mso_schema.schema.id
  template     = var.intersite_template
  name         = var.ap_intersite
  display_name = var.ap_intersite
}

resource "mso_schema_template_anp" "ap_site1" {
  schema_id    = mso_schema.schema.id
  template     = var.site1_template
  name         = var.ap_site1
  display_name = var.ap_site1
}

resource "mso_schema_template_anp" "ap_site2" {
  schema_id    = mso_schema.schema.id
  template     = var.site2_template
  name         = var.ap_site2
  display_name = var.ap_site2
}

# Create a single VRF to which all BDs connect
resource "mso_schema_template_vrf" "vrf_intersite" {
  schema_id    = mso_schema.schema.id
  template     = var.intersite_template
  name         = var.vrf_intersite
  display_name = var.vrf_intersite
}

# Create a BD per EPG. Three altogether. Attach them to the shared VRF.
resource "mso_schema_template_bd" "bd_intersite" {
  schema_id     = mso_schema.schema.id
  template_name = var.intersite_template
  name          = var.bd_intersite
  display_name  = var.bd_intersite
  vrf_name      = mso_schema_template_vrf.vrf_intersite.name
}

resource "mso_schema_template_bd" "bd_site1" {
  schema_id         = mso_schema.schema.id
  template_name     = var.site1_template
  name              = var.bd_site1
  display_name      = var.bd_site1
  vrf_name          = mso_schema_template_vrf.vrf_intersite.name
  vrf_template_name = var.intersite_template
}

resource "mso_schema_template_bd" "bd_site2" {
  schema_id         = mso_schema.schema.id
  template_name     = var.site2_template
  name              = var.bd_site2
  display_name      = var.bd_site2
  vrf_name          = mso_schema_template_vrf.vrf_intersite.name
  vrf_template_name = var.intersite_template
}

# Create EPGs. One per BD. Attach them to same named BD.
resource "mso_schema_template_anp_epg" "epg_intersite" {
  schema_id     = mso_schema.schema.id
  template_name = var.intersite_template
  anp_name      = mso_schema_template_anp.ap_intersite.name
  name          = var.epg_intersite
  display_name  = var.epg_intersite
  bd_name       = mso_schema_template_bd.bd_intersite.name
  vrf_name      = mso_schema_template_vrf.vrf_intersite.name
}

resource "mso_schema_template_anp_epg" "epg_site1" {
  schema_id         = mso_schema.schema.id
  template_name     = var.site1_template
  anp_name          = mso_schema_template_anp.ap_site1.name
  name              = var.epg_site1
  display_name      = var.epg_site1
  bd_name           = mso_schema_template_bd.bd_site1.name
  vrf_name          = mso_schema_template_vrf.vrf_intersite.name
  vrf_template_name = var.intersite_template
}

resource "mso_schema_template_anp_epg" "epg_site2" {
  schema_id         = mso_schema.schema.id
  template_name     = var.site2_template
  anp_name          = mso_schema_template_anp.ap_site2.name
  name              = var.epg_site2
  display_name      = var.epg_site2
  bd_name           = mso_schema_template_bd.bd_site2.name
  vrf_name          = mso_schema_template_vrf.vrf_intersite.name
  vrf_template_name = var.intersite_template
}

# Create two contracts that are used to allow inter-EPG traffic towards GW
# These shared resources belong intersite template
resource "mso_schema_template_filter_entry" "permit_all" {
  schema_id          = mso_schema.schema.id
  template_name      = var.intersite_template
  name               = "permit_any"
  display_name       = "permit_any"
  entry_name         = "permit_any"
  entry_display_name = "permit_any"
  ether_type         = "unspecified"
}

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
}

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
}

# Apply contracts on the right EPGs
resource "mso_schema_template_anp_epg_contract" "epg_intersite_all_site1" {
  schema_id         = mso_schema.schema.id
  template_name     = var.intersite_template
  anp_name          = mso_schema_template_anp.ap_intersite.name
  epg_name          = mso_schema_template_anp_epg.epg_intersite.name
  contract_name     = mso_schema_template_contract.permit_all_site1.contract_name
  relationship_type = "provider"
}

resource "mso_schema_template_anp_epg_contract" "epg_intersite_all_site2" {
  schema_id         = mso_schema.schema.id
  template_name     = var.intersite_template
  anp_name          = mso_schema_template_anp.ap_intersite.name
  epg_name          = mso_schema_template_anp_epg.epg_intersite.name
  contract_name     = mso_schema_template_contract.permit_all_site2.contract_name
  relationship_type = "provider"
}

resource "mso_schema_template_anp_epg_contract" "epg_site1_all" {
  schema_id              = mso_schema.schema.id
  template_name          = var.site1_template
  anp_name               = mso_schema_template_anp.ap_site1.name
  epg_name               = mso_schema_template_anp_epg.epg_site1.name
  contract_name          = mso_schema_template_contract.permit_all_site1.contract_name
  contract_template_name = var.intersite_template
  relationship_type      = "consumer"
}

resource "mso_schema_template_anp_epg_contract" "epg_site2_all" {
  schema_id              = mso_schema.schema.id
  template_name          = var.site2_template
  anp_name               = mso_schema_template_anp.ap_site2.name
  epg_name               = mso_schema_template_anp_epg.epg_site2.name
  contract_name          = mso_schema_template_contract.permit_all_site2.contract_name
  contract_template_name = var.intersite_template
  relationship_type      = "consumer"
}

# Deploy the schema!
# Commented for now since it doesn't seem to work reliably
# resource "mso_schema_template_deploy" "template_deployer_intersite" {
#   schema_id     = mso_schema.schema.id
#   template_name = var.intersite_template
#   site_id       = var.site1_id
#   undeploy      = false
# }

# resource "mso_schema_template_deploy" "template_deployer_site1" {
#   schema_id     = mso_schema.schema.id
#   template_name = var.site1_template
#   site_id       = var.site1_id
#   undeploy      = false
# }
