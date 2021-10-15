# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Ouput definitions for MSO Intersite template.

output "intersite_vrf" {
  description = "The name of the Intersite VRF."
  value       = mso_schema_template_vrf.vrf_intersite.name
}

output "site1_contract" {
  description = "The name of the Site 1 contract."
  value       = mso_schema_template_contract.permit_all_site1.contract_name
}

output "site2_contract" {
  description = "The name of the Site 1 contract."
  value       = mso_schema_template_contract.permit_all_site2.contract_name
}
