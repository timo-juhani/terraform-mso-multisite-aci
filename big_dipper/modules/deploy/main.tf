# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: a demo Terraform file to that declares a sample ACI Multi-Site
# network.

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
