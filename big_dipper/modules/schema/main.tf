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
