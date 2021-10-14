# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Ouput definitions for MSO schema.

# Prints the current site ID of Site 1 allocated by MSO
# output "aci-site1-id" {
#   description = "ACI Site 1's API ID allocated by MSO"
#   value       = data.mso_site.site1.id
# }

# Prints the current site ID of Site 2 allocated by MSO
output "aci-site-id" {
  description = "ACI Site 2's API ID allocated by MSO"
  value       = data.mso_site.site2.id
}

output "schema_id" {
  description = "The ID of the MSO schema created."
  value       = mso_schema.schema.id
}

output "intersite_template" {
  description = "The name of the Intersite template."
  value       = mso_schema.schema.template_name
}

output "site1_template" {
  description = "The name of the Site 1 template."
  value       = mso_schema_template.site1_template.name
}

output "site2_template" {
  description = "The name of the Site 2 template."
  value       = mso_schema_template.site2_template.name
}
