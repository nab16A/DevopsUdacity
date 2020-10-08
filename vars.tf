variable "subscriptionId" {
	type = string
	default = "64c9682c-ca80-483b-b031-ae4bdaf3e808"
}

variable "tenantId" {
	type = string
	default = "d6bbc8a5-46c8-4738-8142-199967a3b00b"
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




