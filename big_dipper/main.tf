# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: a demo Terraform file to that declares a sample ACI Multi-Site
# network.

# NOTE: Current MSO provider works best when run with parallelism=1
# E.g.: terraform apply -parallelism=1

# The provider has changed from "mso" to "ciscodevnet/mso".
# Along with that change comes the need to restructure provider file.

terraform {
  required_providers {
    mso = {
      source = "CiscoDevNet/mso"
    }
  }
}

provider "mso" {
  username = var.mso_username
  password = var.mso_password
  url      = var.mso_url
  insecure = true
  # If Nexus Dashboard is used platform must be set to "nd".
  # Nexus Dashboard is the platform of choice for running MSO (or NDO).
  # However, in existing installations "mso" parameter can be used instead.
  platform = "nd"
}

# Create Multi-site schema with shared Intersite template and site specific
# templates for each ACI site.
module "create_schema" {
  source             = "./modules/schema"
  site2_name         = "acisim-site2"
  tenant             = "big-dipper"
  schema             = "ms-big-dipper"
  intersite_template = "big-dipper-intersite"
  site1_template     = "big-dipper-site1"
  site2_template     = "big-dipper-site2"
}

module "create_intersite_template" {
  source             = "./modules/intersite_template"
  ap_intersite       = "big-dipper-intersite-ap"
  epg_intersite      = "big-dipper-intersite-gw-epg"
  vrf_intersite      = "big-dipper-intersite-vrf"
  bd_intersite       = "big-dipper-intersite-bd"
  c_permit_all_site1 = "big-dipper-site1-contract"
  c_permit_all_site2 = "big-dipper-site2-contract"
  f_permit_all       = "big-dipper-permit-all"
  schema_id          = module.create_schema.schema_id
  intersite_template = module.create_schema.intersite_template
}

module "create_site1_template" {
  source             = "./modules/site_template"
  ap                 = "big-dipper-site1-ap"
  epg                = "big-dipper-site1-epg"
  bd                 = "big-dipper-site1-bd"
  template           = module.create_schema.site1_template
  intersite_template = module.create_schema.intersite_template
  schema_id          = module.create_schema.schema_id
  site_contract      = module.create_intersite_template.site1_contract
  intersite_vrf      = module.create_intersite_template.intersite_vrf
}

module "create_site2_template" {
  source             = "./modules/site_template"
  ap                 = "big-dipper-site2-ap"
  epg                = "big-dipper-site2-epg"
  bd                 = "big-dipper-site2-bd"
  template           = module.create_schema.site2_template
  intersite_template = module.create_schema.intersite_template
  schema_id          = module.create_schema.schema_id
  site_contract      = module.create_intersite_template.site2_contract
  intersite_vrf      = module.create_intersite_template.intersite_vrf
}

module "deploy" {
  source             = "./modules/deploy"
  schema_id          = module.create_schema.schema_id
  site_id            = module.create_schema.aci-site-id
  intersite_template = module.create_schema.intersite_template
  site_template      = module.create_schema.site2_template
}
