####################################################
# Role Assignment Resources
####################################################

data "azurerm_role_definition" "role_assign_dynamic" {
  for_each = var.role_assign_role_definition
  name     = each.value.name
}

locals {
  role_assign_definition_ids = join(", ", [for role_definition in data.azurerm_role_definition.role_assign_dynamic : "${substr(role_definition.id, 51, 36)}"])
}

resource "azurerm_role_assignment" "dynamic" {
  count                = var.role_assignment != {} ? 1 : 0
  scope                = var.role_assign_scope
  role_definition_name = var.role_assign_role_definition_name
  principal_id         = var.role_assign_principal_id
  condition            = var.role_assign_condition == true ? "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.role_assign_definition_ids}})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${local.role_assign_definition_ids}}))" : null
  condition_version    = var.role_assign_condition == true ? var.role_assign_condition_version : null
}


####################################################
# PIM Assignment Resources
####################################################

data "azurerm_role_definition" "pim_dynamic" {
  for_each = var.pim_role_definition
  name     = each.value.name
}

resource "time_static" "example" {}

resource "azurerm_pim_eligible_role_assignment" "pim" {
  for_each           = var.pim_role_definition
  scope              = var.pim_scope
  role_definition_id = var.pim_eligible_role_assignment != null ? "${var.pim_scope}${data.azurerm_role_definition.pim_dynamic[each.key].id}" : null
  principal_id       = var.pim_principal_id

  schedule {
    start_date_time = time_static.example.rfc3339
    expiration {
      duration_days = 365
    }
  }
}
