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

# module "intersite_template" {
#   source = "./intersite_template"
# }

# module "site1_template" {
#   source = "./site1_template"
# }

# module "site2_template" {
#   source = "./site2_template"
# }

# module "deploy" {
#   source = "./deploy"
# }
