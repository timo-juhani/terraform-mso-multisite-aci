# Remember to run Terraform with a tag -parallelism=1
# NOTE: site id is not the same as site name and it can be found with Swagger

resource "mso_tenant" "tenant1" {
  name         = var.tenant1
  display_name = var.tenant1
  description  = "Created by Terraform!"
  site_associations {
    site_id = var.site1_id
  }
}

resource "mso_schema" "schema1" {
  name          = var.schema1
  template_name = var.tenant1
  tenant_id     = mso_tenant.tenant1.id
}

resource "mso_schema_template_anp" "ap1" {
  schema_id    = mso_schema.schema1.id
  template     = var.tenant1
  name         = var.ap1
  display_name = var.ap1
}

resource "mso_schema_site" "schema1_site1" {
  schema_id     = mso_schema.schema1.id
  site_id       = var.site1_id
  template_name = var.tenant1
}

resource "mso_schema_template_vrf" "vrf1" {
  schema_id    = mso_schema.schema1.id
  template     = var.tenant1
  name         = var.vrf1
  display_name = var.vrf1
}

resource "mso_schema_template_bd" "bd1" {
  schema_id     = mso_schema.schema1.id
  template_name = var.tenant1
  name          = var.bd1
  display_name  = var.bd1
  vrf_name      = mso_schema_template_vrf.vrf1.name
}

resource "mso_schema_template_anp_epg" "epg1" {
  schema_id     = mso_schema.schema1.id
  template_name = var.tenant1
  anp_name      = mso_schema_template_anp.ap1.name
  name          = var.epg1
  bd_name       = mso_schema_template_bd.bd1.name
  vrf_name      = mso_schema_template_vrf.vrf1.name
  display_name  = var.epg1
}

resource "mso_schema_template_anp_epg" "epg2" {
  schema_id     = mso_schema.schema1.id
  template_name = var.tenant1
  anp_name      = mso_schema_template_anp.ap1.name
  name          = var.epg2
  bd_name       = mso_schema_template_bd.bd1.name
  vrf_name      = mso_schema_template_vrf.vrf1.name
  display_name  = var.epg2
}

resource "mso_schema_template_contract" "any" {
  schema_id     = mso_schema.schema1.id
  template_name = var.tenant1
  contract_name = "permit_any"
  display_name  = "permit_any"
  filter_type   = "bothWay"
  scope         = "context"
  filter_relationships = {
    filter_schema_id     = mso_schema.schema1.id
    filter_template_name = var.tenant1
    filter_name          = mso_schema_template_filter_entry.any.name
  }
  directives = ["none", "log"]
}

resource "mso_schema_template_filter_entry" "any" {
  schema_id          = mso_schema.schema1.id
  template_name      = var.tenant1
  name               = "permit_any"
  display_name       = "permit_any"
  entry_name         = "permit_any"
  entry_display_name = "permit_any"
  destination_from   = "unspecified"
  destination_to     = "unspecified"
  source_from        = "unspecified"
  source_to          = "unspecified"
  arp_flag           = "unspecified"
}

resource "mso_schema_template_anp_epg_contract" "epg1_any" {
  schema_id         = mso_schema.schema1.id
  template_name     = var.tenant1
  anp_name          = mso_schema_template_anp.ap1.name
  epg_name          = mso_schema_template_anp_epg.epg1.name
  contract_name     = mso_schema_template_contract.any.contract_name
  relationship_type = "provider"
}

resource "mso_schema_template_anp_epg_contract" "epg2_any" {
  schema_id         = mso_schema.schema1.id
  template_name     = var.tenant1
  anp_name          = mso_schema_template_anp.ap1.name
  epg_name          = mso_schema_template_anp_epg.epg2.name
  contract_name     = mso_schema_template_contract.any.contract_name
  relationship_type = "consumer"
}

resource "mso_schema_site_bd" "bd1" {
  schema_id     = mso_schema.schema1.id
  template_name = var.tenant1
  bd_name       = mso_schema_template_bd.bd1.name
  site_id       = var.site1_id
  host_route    = false
}

resource "mso_schema_site_bd_subnet" "sn1" {
  schema_id     = mso_schema.schema1.id
  template_name = var.tenant1
  site_id       = var.site1_id
  bd_name       = mso_schema_template_bd.bd1.name
  ip            = "10.1.1.1/24"
  description   = "Site 1 Subnet 1"
  shared        = false
  scope         = "private"
}

resource "mso_schema_template_deploy" "template_deployer" {
  schema_id     = mso_schema.schema1.id
  template_name = var.tenant1
  site_id       = var.site1_id
  undeploy      = false
}
