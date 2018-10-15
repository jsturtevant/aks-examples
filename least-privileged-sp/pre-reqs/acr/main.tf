resource "azurerm_resource_group" "rg-acr" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_container_registry" "acr" {
  resource_group_name      = "${azurerm_resource_group.rg-acr.name}"
  location                 = "${azurerm_resource_group.rg-acr.location}"
  name                = "${var.acr_name}"
  admin_enabled       = false
  sku                 = "${var.acr_sku}"
}
