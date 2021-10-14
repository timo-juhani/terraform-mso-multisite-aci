# Author: Timo-Juhani Karjalainen, tkarjala@cisco.com, Cisco CX
# Description: a demo Terraform file to that declares a sample ACI Multi-Site
# network.

module "schema" {
  source = "./schema"
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
