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
    platform = "mso"
}