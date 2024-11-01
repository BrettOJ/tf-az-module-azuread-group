resource "azuread_group" "ad_group" {
  display_name     = var.display_name
  owners           = var.owners
  security_enabled = var.security_enabled
  members = var.group_members
}