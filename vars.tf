variable "subscriptionId" {
	type = string
	default = "..."
}

variable "tenantId" {
	type = string
	default = "..."
}

variable "resource_group_name" {
	description = "Name of the resource group."
	type = string
	default = "test-rg"
}

variable "location" {
	type = string
	default = "northeurope"
}

variable "vnet_name" {
	description = "Name of the vnet to create"
	type = string
	default = "project-vnet"
}

variable "address_space" {
	type = list(string)
	default = ["10.0.0.0/24"]
	description = "The address space used by the virtual network."
}

variable "subnet_name" {
	type = string
	default = "internal"
	description = "Name of the public subnet inside the vnet."
}

variable "subnet_addr_pref" {
	type = list(string)
	default = ["10.0.1.0/24"]
	description = "The address prefix to use for the subnet."
}

variable "usr" {
	type = string
	default = "adminuser"
}

variable "pwd" {
	type = string
	default = "P@ssw0rd1234!"
}

variable "vm_id" {
	type = string
	default = "/subscriptions/..../resourceGroups/project-rg/providers/Microsoft.Compute/images/projectPackerImage"
}



