# Prints the current site ID of Site 1 allocated by MSO
# output "aci-site1-id" {
#   description = "ACI Site 1's API ID allocated by MSO"
#   value       = data.mso_site.site1.id
# }

# Prints the current site ID of Site 2 allocated by MSO
output "aci-site2-id" {
  description = "ACI Site 2's API ID allocated by MSO"
  value       = data.mso_site.site2.id
}
