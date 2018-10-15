resource "azurerm_resource_group" "rg_public_ips" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

resource "azurerm_public_ip" "ips" {
  name                         = "${var.public_ip_name}"
  location                     = "${azurerm_resource_group.rg_public_ips.location}"
  resource_group_name          = "${azurerm_resource_group.rg_public_ips.name}"
  public_ip_address_allocation = "static"
}
