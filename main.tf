variable "subscription_id" {
    type = string
    default = "049cc0b9-2696-4e70-871b-4366be487c19"
    description = "tf-dev-subscription id"
  
}
variable "client_id" {
    type = string 
    default = "4c7fc100-4cbc-4b41-98ff-bea4cfe18a56"
    description = "tf-dev-cleintid"
  
}
variable "client_secret" {
    type = string
    default = "lwK8Q~QwSPpTMdHAMmakn24YNDsrGfRSCSzo6aLk"
    description = "tf-dev-client secret"
  
}
variable "tenant_id" {
    type = string
    default = "477cf0a5-266c-4331-8f0a-865f4622d888"
    description = "tf-dev-tenantid"
  
}
terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version= "3.27.0"
      }
    }
  
}
provider "azurerm" {
  features {
    
  }
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id

}

resource "azurerm_resource_group" "tflabelrg101" {
    name = "tfrg104"
    location = "East US"
    tags = {
      "name" = "tf-rg-101"
    }
  
}

resource "azurerm_virtual_network" "tflabelvnet101" {
    name = "tfvent101"
    resource_group_name = azurerm_resource_group.tflabelrg101.name
    location = azurerm_resource_group.tflabelrg101.location
    address_space = [ "10.70.0.0/16" ]
  
}
resource "azurerm_subnet" "tflabelwebsubnet101" {
    name = "tfwebsubnet101"
    resource_group_name = azurerm_resource_group.tflabelrg101.name
    virtual_network_name = azurerm_virtual_network.tflabelvnet101.name
    address_prefixes = [ "10.70.1.0/24" ]
  
}
resource "azurerm_subnet" "tflabelappsubnet101" {
    name = "tfappsubnet101"
    resource_group_name = azurerm_resource_group.tflabelrg101.name
    virtual_network_name = azurerm_virtual_network.tflabelvnet101.name
    address_prefixes = [ "10.70.2.0/24" ]
  
}
resource "azurerm_subnet" "tflabeldbsubnet101" {
    name = "tfdbsubnet101"
    resource_group_name = azurerm_resource_group.tflabelrg101.name
    virtual_network_name = azurerm_virtual_network.tflabelvnet101.name
    address_prefixes = [ "10.70.3.0/24" ]
  
}
resource "azurerm_public_ip" "tflabelwebpublicip101" {
  name = "tfwebpublicip"
  resource_group_name = azurerm_resource_group.tflabelrg101.name
  location = azurerm_resource_group.tflabelrg101.location
  allocation_method = "Static"
  
}
resource "azurerm_network_interface" "tflabelwebnic101" {
  name = "tfwebnic"
  location = azurerm_resource_group.tflabelrg101.location
  resource_group_name = azurerm_resource_group.tflabelrg101.name
  ip_configuration {
    name = "external"
    subnet_id = azurerm_subnet.tflabelwebsubnet101.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tflabelwebpublicip101.id
  }
  
}


resource "azurerm_public_ip" "tflabelapppublicip101" {
  name = "tfapppublicip"
  resource_group_name = azurerm_resource_group.tflabelrg101.name
  location = azurerm_resource_group.tflabelrg101.location
  allocation_method = "Static"
  
}

resource "azurerm_network_interface" "tflabelappnic101" {
  name = "tfappnic"
  location = azurerm_resource_group.tflabelrg101.location
  resource_group_name = azurerm_resource_group.tflabelrg101.name
  ip_configuration {
    name = "external"
    subnet_id = azurerm_subnet.tflabelappsubnet101.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tflabelapppublicip101.id
  }
  
}

<<<<<<< HEAD
=======
resource "azurerm_linux_virtual_machine" "tflabelappserver101" {
  name = "tfappserver"
  resource_group_name = azurerm_resource_group.tflabelrg101.name
  location = azurerm_resource_group.tflabelrg101.location
  size = "Standard_F2"
  admin_username = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.tflabelappnic101.id,
  ]
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
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
  
}
>>>>>>> f47278aba05c6c61ddfe2aed75a9691093dc7f3b
