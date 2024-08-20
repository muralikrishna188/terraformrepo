terraform {

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.114.0"
    }
  }
}
variable "subscription_id" {
    type = string
    default = "049cc0b9-2696-4e70-871b-4366be487c19"
    description = "mobilesubscription"

  
}
variable "client_id" {
    type = string
    default = "432d30c2-3497-4917-b30b-0cdaf2c62cdb"
    description = "mobileappsucription-clientid"
  
}
variable "client_secret" {
    type = string
    default = ""
    description = "client secret"
  
}
variable "tenant_id" {
    type = string
    default = "477cf0a5-266c-4331-8f0a-865f4622d888"
    description = "tenant id"
  
}
provider "azurerm" {
    features {
      
    }
    subscription_id = var.subscription_id
    client_id = var.client_id
    client_secret = var.client_secret
    tenant_id = var.tenant_id
}
resource "azurerm_resource_group" "myrblabel101" {
  name = "myapprg587"
  location = "eastus"
  tags = {
    name = "myrg"
  }
  
}
resource "azurerm_virtual_network" "mobilenetworklabel" {
  name = "mobilenetowrk"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  address_space = [ "10.80.0.0/16" ]

  
}
#webserver
resource "azurerm_subnet" "websubnetlabel" {
  name = "websubnet"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  virtual_network_name = azurerm_virtual_network.mobilenetworklabel.name
  address_prefixes = ["10.80.1.0/24"]
  
}

resource "azurerm_public_ip" "azweb101publiciplabel" {
  name = "webpublicip101"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  allocation_method = "Static"
  
}
resource "azurerm_network_interface" "azwebnic101label" {
  name = "web101nic"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  ip_configuration {
    name = "web101nicocnfig"
    subnet_id = azurerm_subnet.websubnetlabel.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.azweb101publiciplabel.id
  }
  
}
resource "azurerm_network_security_group" "aznsg101label" {
  name = "aznsg101"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  
}
resource "azurerm_network_security_rule" "aznsgrule101" {
  name = "aznsgrule101"
  priority = "100"
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  network_security_group_name = azurerm_network_security_group.aznsg101label.name

  
}
resource "azurerm_subnet_network_security_group_association" "aznsgattach001" {
  subnet_id = azurerm_subnet.websubnetlabel.id
  network_security_group_id = azurerm_network_security_group.aznsg101label.id
  
}
resource "azurerm_linux_virtual_machine" "azweb101vmlabel" {
  name = "azwebserver101"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  size = "Standard_F2"
  admin_username = "adminuser"
  network_interface_ids = [azurerm_network_interface.azwebnic101label.id,]
  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")

  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
  
}
#Appserver
resource "azurerm_subnet" "appsubnetlabel" {
  name = "appsubnet"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  virtual_network_name = azurerm_virtual_network.mobilenetworklabel.name
  address_prefixes = ["10.80.2.0/24"]
  
}
resource "azurerm_public_ip" "azapp101publiciplabel" {
  name = "apppublicip101"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  allocation_method = "Static"
  
}
resource "azurerm_network_interface" "azappnic101label" {
  name = "app101nic"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  ip_configuration {
    name = "app101nicocnfig"
    subnet_id = azurerm_subnet.appsubnetlabel.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.azapp101publiciplabel.id
  }
  
}
resource "azurerm_linux_virtual_machine" "azapp101vmlabel" {
  name = "azappserver101"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  size = "Standard_F2"
  admin_username = "adminuser"
  network_interface_ids = [azurerm_network_interface.azappnic101label.id,]
  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")

  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
  
}

#DBServer
resource "azurerm_subnet" "dbsubnetlabel" {
  name = "dbsubnet"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  virtual_network_name = azurerm_virtual_network.mobilenetworklabel.name
  address_prefixes = ["10.80.3.0/24"]
  
}
resource "azurerm_public_ip" "azdb101publiciplabel" {
  name = "dbpublicip101"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  allocation_method = "Static"
  
}
resource "azurerm_network_interface" "azdbnic101label" {
  name = "db101nic"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  ip_configuration {
    name = "db101nicocnfig"
    subnet_id = azurerm_subnet.dbsubnetlabel.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.azdb101publiciplabel.id
  }
  
}
resource "azurerm_linux_virtual_machine" "azdb101vmlabel" {
  name = "azdbserver101"
  resource_group_name = azurerm_resource_group.myrblabel101.name
  location = azurerm_resource_group.myrblabel101.location
  size = "Standard_F2"
  admin_username = "adminuser"
  network_interface_ids = [azurerm_network_interface.azdbnic101label.id,]
  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")

  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    version = "latest"
  }
  
}