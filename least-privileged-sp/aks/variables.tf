variable "client_id" {
  type        = "string"
  description = "Client ID of service principal."
}

variable "client_secret" {
  type        = "string"
  description = "Password/secreet of service principal."
}

variable "agent_count" {
  default     = 1
  description = "Number of worker nodes to deploy in the cluster."
}

variable "dns_prefix" {
  type        = "string"
  description = "Prefix for cluster DNS name."
}

variable "cluster_name" {
  type        = "string"
  description = "Cluster resource name."
}

variable "resource_group_name" {
  type        = "string"
  description = "Resource group name to deploy AKS resources in."
}

variable "location" {
  type        = "string"
  description = "Azure region to deploy the cluster in."
}

variable "subscription_id" {
  type        = "string"
  description = "Subscription ID"
}

variable "vnet_subnet_id" {
  type        = "string"
  description = "Fully qualified resource ID for the vnet subnet to bind the nodes to."
}

variable "vm_size" {
  default     = "Standard_DS3_v2"
  type        = "string"
  description = "The size/type of the VM we will provide K8s for nodes."
}

variable "os_type" {
  default     = "Linux"
  type        = "string"
  description = "Kubernetes only works on Linux VMs"
}

variable "os_disk_size_gb" {
  default     = 30
  description = "The disk size of VMs, default is 30 GB."
}

