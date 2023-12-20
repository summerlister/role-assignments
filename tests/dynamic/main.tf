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

data "azurerm_subscription" "primary" {
}

data "azurerm_client_config" "client" {
}

data "azurerm_role_definition" "dynamic" {
  for_each = local.role_definitions
  name     = each.value.name
}


###################################################
# Locals
###################################################

locals {
  role_definitions = {
    AcrDelete = {
      name = "AcrDelete"
    }
    AcrImageSigner = {
      name = "AcrImageSigner"
    }
    AcrPull = {
      name = "AcrPull"
    }
    AcrPush = {
      name = "AcrPush"
    }
    # add a new role here = {
    #   name = "add a new role here"
    # }
  }
}

locals {
  role_definition_ids = join(", ", [for role_definition in data.azurerm_role_definition.dynamic : "${substr(role_definition.id, 51, 36)}"])
}


###################################################
# Modules
###################################################

module "role_assignment" {
  source               = "git::https://github.com/summerlister/role-assignments.git?ref=v1.0.0"
  role_definition_name = "User Access Administrator"
  subscription_id      = data.azurerm_subscription.primary.id
  principal_id         = data.azurerm_client_config.client.object_id
  condition            = "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.role_definition_ids}})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.role_definition_ids}}))"
}
