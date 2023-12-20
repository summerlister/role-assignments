####################################################
# Resources
####################################################

resource "azurerm_role_assignment" "dynamic" {
  scope                = var.subscription_id
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id
  condition            = var.condition
  condition_version    = var.condition != null ? var.condition_version : null
}
