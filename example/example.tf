data "azuread_client_config" "current" {}

module "azuread_user" {
    source = "git::https://github.com/BrettOJ/tf-az-module-azuread-user?ref=main"
  display_name        = var.user_display_name
  password            = var.password
  user_principal_name = var.user_principal_name
}

module "azuread_group" {
    source = "git::https://github.com/BrettOJ/tf-az-module-azuread-group?ref=main"
  display_name     = var.group_display_name
  owners           = var.owners
  security_enabled = var.security_enabled
  members = var.group_members
}