# Terraforming Multi-Cloud Networks with MSO

![image](terraforming.jpg)

Cisco ACI comes with a powerful REST API that allows treating the infrastructure as code. Terraform is a tool designed and created by HashiCorp to automate provisioning and managing cloud and infrastructure resources. Bringing this capability on the table, configuring or re-building your infra is a matter of moments rather than hours.

This repository expands the work done in my "terraforming_aci" repository also found from GitHub. This time though, instead of automating provisioning of single site APICs, multi-cloud capabilities given by Cisco MSO are harnessed with the help of Terraform. 

To run this you need MSO instance which can be deployed on an ESXi, for isntance. Then connecting MSO to either physical or simulator APICs gives a solid development environment. 

To start terraforming your networks:
- Install Terraform (https://www.terraform.io/)
- Clone this repo
- Check out the variables.tf file and modify them
- Run terraform init to get the needed providers
- Run terraform plan to see what changes are hitting the pipeline
- Run terraform apply when you are are ready to provision the configuration
- Finally if you want to delete your configuration run terraform destroy

Terraform tracks the state of the infrastructure and thus only provisions what has changed.

### On Current MSO Provider 

Provider: ciscodevnet/mso 0.3.1

It works best when run with parallelism=1 tag. The reason for this seems to be 
that TF likes to deal with flat data structures whereas ACI's data model is 
highly hierarchical. Normally TF would like to run 10 concurrent tasks at the 
same time, which seems to produce issues when using the current version of MSO
provider. The data model TF sees is quite complex and if your run multiple 
things at the same time, no wonder why things break. See the graph.svg of the 
data model provider wants to create if you don't believe otherwise. 

You can set parallelism to 1 evrytime you issue TF commands, but this get
tedious after some time.

```
terraform apply -parallelism=1
```

You will be better of by simply defining the following environmental variables 
to your .bashrc or .profile so that the tag is included automatically when 
issuing plan, apply or destroy command.

Environmental Variable Definitions:
```
export TF_CLI_ARGS_apply="-parallelism=1"
export TF_CLI_ARGS_plan="-parallelism=1"
export TF_CLI_ARGS_destroy="-parallelism=1"
```

Remember to update the settings by:
```
source ~/.bashrc (or .profile)
```