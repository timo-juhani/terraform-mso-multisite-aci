# Terraforming Multi-Cloud Networks with MSO

![image](terraforming.jpg)

Cisco ACI comes with a powerful REST API that allows treating the infrastructure as code. Terraform is a tool designed and created by HashiCorp to automate provisioning and managing cloud and infrastructure resources. Bringing this capability on the table, configuring or re-building your infra is a matter of moments rather than hours.

This repository expands the work done in my "terraforming_aci" repository also found from GitHub. This time though, instead of automating provisioning of single site APICs, multi-cloud capabilities given by Cisco MSO are harnessed with the help of Terraform. 

To run this you need MSO instance which can be deployed on an ESXi, for isntance. Then connecting MSO to either physical or simulator APICs gives a solid development environment. 

To start terraforming your networks:

    Install Terraform (https://www.terraform.io/)
    Clone this repo
    Check out the variables.tf file and modify them
    Run terraform init to get the needed providers
    Run terraform plan to see what changes are hitting the pipeline
    Run terraform apply when you are are ready to provision the configuration
    Finally if you want to delete your configuration run terraform destroy

Terraform tracks the state of the infrastructure and thus only provisions what has changed.