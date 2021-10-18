# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: a demo Terraform file to that declares access ports definitions
# on leafs via MSO.

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



################################################################################
# Create Ports
################################################################################

module "create_acess_port" {
  source        = "./modules/create_access_port"
  site_name     = "acisim-site2"
  schema_name   = "ms-big-dipper"
  template_name = "big-dipper-site2"
  ap            = "big-dipper-site2-ap"
  ep            = "big-dipper-site2-epg"
  domain        = "leo-static"
  pod           = "pod-1"
  leaf          = "101"
  path          = "eth1/10"
  vlan_id       = 100
}