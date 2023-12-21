###################################################
# Providers
###################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {
  }
}


###################################################
# Resources
###################################################

data "azurerm_client_config" "client" {
}


###################################################
# Locals
###################################################

locals {
  scope = {
    "/subscriptions/sub_id" = { #connectivity subscription
      role_assignment = {
      }
      pim_eligible_role_assignment = {
        principal_id = "object_id" #user/group/service principal object id
        role_definitions = {
          Reader = {
            name = "Reader"
          }
          Contributor = {
            name = "Contributor"
          }
          # add a new role here = {
          #   name = "add a new role here"
          # }
        }
      }
    }
    "/subscriptions/sub_id" = { #core subscription
      role_assignment = {
        principal_id         = data.azurerm_client_config.client.object_id #user/group/service principal object id
        role_definition_name = "User Access Administrator"
        role_definitions = {
          AcrDelete = {
            name = "AcrDelete"
          }
          AcrImageSigner = {
            name = "AcrImageSigner"
          }
          # AcrPull = {
          #   name = "AcrPull"
          # }
          # add a new role here = {
          #   name = "add a new role here"
          # }
        }
      }
      pim_eligible_role_assignment = {
        # principal_id = "object_id" #user/group/service principal object id
        # role_definitions = {
        #   Contributor = {
        #     name = "Contributor"
        #   }
        # }
      }
    }
  }
}


###################################################
# Modules
###################################################

module "role_assignment" {
  for_each                         = local.scope
  source                           = "../.."
  role_assignment                  = each.value.role_assignment
  role_assign_scope                = each.key
  role_assign_role_definition_name = each.value.role_assignment != {} ? each.value.role_assignment.role_definition_name : null
  role_assign_role_definition      = each.value.role_assignment != {} ? each.value.role_assignment.role_definitions : {}
  role_assign_principal_id         = each.value.role_assignment != {} ? each.value.role_assignment.principal_id : null
  pim_eligible_role_assignment     = each.value.pim_eligible_role_assignment
  pim_scope                        = each.key
  pim_role_definition              = each.value.pim_eligible_role_assignment != {} ? each.value.pim_eligible_role_assignment.role_definitions : {}
  pim_principal_id                 = each.value.pim_eligible_role_assignment != {} ? each.value.pim_eligible_role_assignment.principal_id : null
}
