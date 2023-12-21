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

data "azurerm_role_definition" "builtinAcrDelete" {
  name = "AcrDelete"
}

data "azurerm_role_definition" "builtinAcrImageSigner" {
  name = "AcrImageSigner"
}

data "azurerm_role_definition" "builtinAcrPull" {
  name = "AcrPull"
}

resource "azurerm_role_assignment" "static" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Owner"
  principal_id         = "object_id"
  condition            = "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {c2f4ef07-c644-48eb-af81-4b1b4947fb11, 6cef56e8-d556-48e5-a04f-b8e64114680f, 7f951dda-4ed3-4680-a7ca-43fe172d538d})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {c2f4ef07-c644-48eb-af81-4b1b4947fb11, 6cef56e8-d556-48e5-a04f-b8e64114680f, 7f951dda-4ed3-4680-a7ca-43fe172d538d}))"
  condition_version    = "2.0"
}