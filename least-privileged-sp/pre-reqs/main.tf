module "vnet" {
    source = "vnet"

    resource_group_name="tmp-lpsp-vnet"
    resource_group_location="eastus"
    network_name="lpsp-network"
}

module "acr" {
    source = "acr"

    resource_group_name="tmp-lpsp-acr"
    resource_group_location="eastus"
    acr_name="lpspacr"
}

module "ips" {
  source = "public-ips"
  
    resource_group_name="tmp-lpsp-ip"
    resource_group_location="eastus"
    public_ip_name="tmp-lpsp-ip"
}
