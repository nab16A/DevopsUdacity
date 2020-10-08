provider "azurerm" {
	version = "=2.30.0"
	subscription_id = var.subscriptionId
	tenant_id = var.tenantId
	features {}
}

resource "azurerm_resource_group" "vnetproject" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnetproject" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = azurerm_resource_group.vnetproject.location
  resource_group_name = azurerm_resource_group.vnetproject.name
}

resource "azurerm_subnet" "internal" { 
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vnetproject.name
  virtual_network_name = azurerm_virtual_network.vnetproject.name
  address_prefixes     = var.subnet_addr_pref
}

resource "azurerm_network_security_group" "vnet" {
	name					= "securityGroup"
	location				= azurerm_resource_group.vnetproject.location
	resource_group_name		= azurerm_resource_group.vnetproject.name
	
	security_rule {
		name						= "projrule"
		priority					= 200
		direction					= "Inbound"
		access						= "Allow"
		protocol					= "*"
		source_port_range			= "*"
		destination_port_range		= "*"
		source_address_prefix		= "VirtualNetwork"
		destination_address_prefix	= "VirtualNetwork"
	}
}

resource "azure_security_group_rule" "internet" {
	name						= "internat-access-rule"
	security_group_names		= [azurerm_network_security_group.vnet.name]
	type						= "Inbound"
	action						= "Deny"
	priority					= 200
	source_address_prefix		= "Internet"
	source_port_range			= "*"
	destination_address_prefix	= ["10.0.0.0/24"]
	destination_port_range		= "*"
	protocol					= "*"
}