resource "azurerm_resource_group" "computeRG" {
  name     = var.computergname
  location = var.location
}
module "hubmanagementvm" {
  source        = "./modules/linuxvmhub"
  rgname        = azurerm_resource_group.computeRG.name
  location      = var.location
  subnetid      = module.hubnetwork.vnet_subnets[1]
  vmname        = var.hub_vm_hostname
  vmpassword    = var.vm_admin_pwd
  adminusername = var.vm_admin_user
  vmsize        = var.vm_size
   }

module "linuxvmspoke1" {
  source        = "./modules/linuxvmspoke"
  rgname        = azurerm_resource_group.computeRG.name
  location      = var.location
  subnetid      = module.spoke1network.vnet_subnets[0]
  vmname        = var.spoke1_vm_hostname
  vmpassword    = var.vm_admin_pwd
  adminusername = var.vm_admin_user
  vmsize        = var.vm_size
   }

module "linuxvmspoke2" {
  source        = "./modules/linuxvmspoke"
  rgname        = azurerm_resource_group.computeRG.name
  location      = var.location
  subnetid      = module.spoke2network.vnet_subnets[0]
  vmname        = var.spoke2_vm_hostname
  vmpassword    = var.vm_admin_pwd
  adminusername = var.vm_admin_user
  vmsize        = var.vm_size
   } 

  resource "azurerm_virtual_machine_extension" "spokevm1extension" {
  name                 = "hostname"
  virtual_machine_id   = module.linuxvmspoke1.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
 settings = <<SETTINGS
    {                         
        "fileUris": ["https://raw.githubusercontent.com/sdcscripts/terraform-az-firewallnva/master/supporting/webserver.sh"],
        "commandToExecute": "bash webserver.sh"
 
    }
SETTINGS

  }

  resource "azurerm_virtual_machine_extension" "spokevm2extension" {
  name                 = "hostname"
  virtual_machine_id   = module.linuxvmspoke2.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
 settings = <<SETTINGS
    {                         
        "fileUris": ["https://raw.githubusercontent.com/sdcscripts/terraform-az-firewallnva/master/supporting/webserver.sh"],
        "commandToExecute": "bash webserver.sh"
 
    }
SETTINGS

  }