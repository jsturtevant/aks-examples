resource "azurerm_resource_group" "k8s-resource-group" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "k8s-cluster-name" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s-resource-group.location}" 
  resource_group_name = "${azurerm_resource_group.k8s-resource-group.name}"   
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version = "1.10.8"

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "${var.vm_size}"
    os_type         = "${var.os_type}"
    os_disk_size_gb = "${var.os_disk_size_gb}"
    vnet_subnet_id  = "${var.vnet_subnet_id}"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  network_profile {
    network_plugin = "azure"
  }
}
