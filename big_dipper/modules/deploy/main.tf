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
# Attach Schema to Site
################################################################################

# Add Intersite network to Site 
resource "mso_schema_site" "add_intersite" {
  schema_id     = var.schema_id
  site_id       = var.site_id
  template_name = var.intersite_template
}

# Add Site specific network
resource "mso_schema_site" "add_site_details" {
  schema_id     = var.schema_id
  site_id       = var.site_id
  template_name = var.site_template
}

################################################################################
# Deploy The Schema to ACI Site
################################################################################

# Deploy Intersite network configuration to site
resource "mso_schema_template_deploy" "deploy_intersite" {
  schema_id     = var.schema_id
  template_name = var.intersite_template
  site_id       = var.site_id
  undeploy      = false
}

# Deploy Site 2 specific network configuration to site
resource "mso_schema_template_deploy" "deploy_site_details" {
  schema_id     = var.schema_id
  template_name = var.site_template
  site_id       = var.site_id
  undeploy      = false
}
