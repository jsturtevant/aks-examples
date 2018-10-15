
variable "resource_group_name" {
  type        = "string"
  description = "Name of the azure resource group."
}

variable "resource_group_location" {
  type        = "string"
  description = "Location of the azure resource group."
}

variable "acr_name" {
  type        = "string"
  description = "Name for the container registry."
}

variable "acr_sku" {
  type        = "string"
  description = "SKU for the container registry."
  default     = "Basic"
}