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


# WARNING! Before configuring anything on Tenants make sure to confirm that
# the Fabric Access Policy is up to date.


################################################################################
# Add a domain to EPG
################################################################################

# Add domain to EPG

module "add_leo_static_domain" {
  source        = "./modules/add_domain"
  site_name     = "acisim-site2"
  schema_name   = "ms-big-dipper"
  template_name = "big-dipper-site2"
  ap            = "big-dipper-site2-ap"
  ep            = "big-dipper-site2-epg"
  domain        = "leo-static"
}

################################################################################
# Add access ports
################################################################################

# Access port to e10
module "create_ap_e10" {
  source        = "./modules/create_access_port"
  site_name     = "acisim-site2"
  schema_name   = "ms-big-dipper"
  template_name = "big-dipper-site2"
  ap            = "big-dipper-site2-ap"
  ep            = "big-dipper-site2-epg"
  pod           = "pod-1"
  leaf          = "101"
  path          = "eth1/10"
  vlan_id       = 100
}

# Access port to e11
module "create_ap_e11" {
  source        = "./modules/create_access_port"
  site_name     = "acisim-site2"
  schema_name   = "ms-big-dipper"
  template_name = "big-dipper-site2"
  ap            = "big-dipper-site2-ap"
  ep            = "big-dipper-site2-epg"
  pod           = "pod-1"
  leaf          = "101"
  path          = "eth1/11"
  vlan_id       = 100
}

################################################################################
# Add portchannel ports
################################################################################


# Port-Channel port to e12
module "create_dpc_e12" {
  source        = "./modules/create_direct_portchannel"
  site_name     = "acisim-site2"
  schema_name   = "ms-big-dipper"
  template_name = "big-dipper-site2"
  ap            = "big-dipper-site2-ap"
  ep            = "big-dipper-site2-epg"
  pod           = "pod-1"
  leaf          = "101"
  path          = "leo-server-2"
  vlan_id       = 100
}

# Port-Channel port to e13
module "create_dpc_e13" {
  source        = "./modules/create_direct_portchannel"
  site_name     = "acisim-site2"
  schema_name   = "ms-big-dipper"
  template_name = "big-dipper-site2"
  ap            = "big-dipper-site2-ap"
  ep            = "big-dipper-site2-epg"
  pod           = "pod-1"
  leaf          = "101"
  path          = "leo-server-2"
  vlan_id       = 100
}

################################################################################
# Add VPC ports
################################################################################

# Port-Channel port to e14
module "create_vpc_e14" {
  source        = "./modules/create_virtual_portchannel"
  site_name     = "acisim-site2"
  schema_name   = "ms-big-dipper"
  template_name = "big-dipper-site2"
  ap            = "big-dipper-site2-ap"
  ep            = "big-dipper-site2-epg"
  pod           = "pod-1"
  leaf          = "101"
  path          = "leo-server-1"
  vlan_id       = 100
}

# Port-Channel port to e15
module "create_vpc_e15" {
  source        = "./modules/create_virtual_portchannel"
  site_name     = "acisim-site2"
  schema_name   = "ms-big-dipper"
  template_name = "big-dipper-site2"
  ap            = "big-dipper-site2-ap"
  ep            = "big-dipper-site2-epg"
  pod           = "pod-1"
  leaf          = "102"
  path          = "leo-server-1"
  vlan_id       = 100
}
