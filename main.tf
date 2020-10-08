provider "azurerm" {
	subscription_id = var.subscriptionId
	tenant_id = var.tenantId
	features {}
}

resource "azurerm_resource_group" "vnetproject" {
  name     = var.resource_group_name
  location = var.location
  
  tags = {
    environment = "projectcode"
  }
}

resource "azurerm_virtual_network" "vnetproject" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = azurerm_resource_group.vnetproject.location
  resource_group_name = azurerm_resource_group.vnetproject.name
  
  tags = {
    environment = "projectcode"
  }
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

resource "azurerm_network_security_rule" "internet" {
	name							= "internat-access-rule"
	network_security_group_name		= "azurerm_network_security_group.vnet.name"
	direction						= "Inbound"
	access							= "Deny"
	priority						= 200
	source_address_prefix			= "Internet"
	source_port_range				= "*"
	destination_address_prefix		= "10.0.0.0/24"
	destination_port_range			= "*"
	protocol						= "*"
	resource_group_name				= azurerm_resource_group.vnetproject.name
}

resource "azurerm_network_interface" "vnetproject" {
	name				= "vnetproject-nic"
	location			= azurerm_resource_group.vnetproject.location
	resource_group_name = azurerm_resource_group.vnetproject.name
	
	ip_configuration {
		name							= "testconfiguration"
		subnet_id						= azurerm_subnet.internal.id
		private_ip_address_allocation	= "Dynamic"
	}
}

resource "azurerm_public_ip" "vnetproject" {
  name				   		= "test"
  location			   		= azurerm_resource_group.vnetproject.location
  resource_group_name  		= azurerm_resource_group.vnetproject.name
  allocation_method	   		= "Dynamic"
  idle_timeout_in_minutes   = 30
  
  tags = {
    environment = "projectcode"
  }
}

resource "azurerm_lb" "vnetproject" {
  name                = "LoadBalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.vnetproject.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vnetproject.id
  }
}

resource "azurerm_lb_backend_address_pool" "vnetproject" {
  resource_group_name = azurerm_resource_group.vnetproject.name
  loadbalancer_id     = azurerm_lb.vnetproject.id
  name                = "BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "vnetproject" {
  network_interface_id    = azurerm_network_interface.vnetproject.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.vnetproject.id
}

resource "azurerm_image" "vnetproject" {
	name						= "packertoterra"
	location					= var.location
	resource_group_name			= azurerm_resource_group.vnetproject.name
}

resource "azurerm_linux_virtual_machine" "vnetproject" { 
  name                            = "project-vm"
  resource_group_name             = azurerm_resource_group.vnetproject.name
  location                        = var.location
  size                            = "Standard_D2_v3"
  admin_username                  = var.usr 
  admin_password                  = var.pwd  
  disable_password_authentication = false            
  network_interface_ids = [azurerm_network_interface.vnetproject.id]
  
  os_disk {
	storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  source_image_id = var.vm_id
}