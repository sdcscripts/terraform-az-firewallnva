// vnet creation 
module "hubnetwork" {
    source              = "./modules/networkbuild"
    vnet_name           = var.hub_vnet_name
    resource_group_name = "${var.hub_vnet_name}-rg"
    location            = "uksouth"
    address_space       = "10.0.0.0/16"
    subnet_prefixes     = ["10.0.1.0/26", "10.0.2.0/24", "10.0.3.0/24"]
    subnet_names        = ["AzureFirewallSubnet", "ManagementSubnet", "SharedServices"]
}

module "spoke1network" {
    source              = "./modules/networkbuild"
    vnet_name           = var.spoke1_vnet_name
    resource_group_name = "${var.spoke1_vnet_name}-rg"
    location            = "uksouth"
    address_space       = "10.100.0.0/16"
    subnet_prefixes     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
    subnet_names        = ["WebTier", "LogicTier", "DatabaseTier"]
}
module "spoke2network" {
    source              = "./modules/networkbuild"
    vnet_name           = var.spoke2_vnet_name
    resource_group_name = "${var.spoke2_vnet_name}-rg"
    location            = "uksouth"
    address_space       = "10.200.0.0/16"
    subnet_prefixes     = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
    subnet_names        = ["WebTier", "LogicTier", "DatabaseTier"]
}

// nsg associations 

resource "azurerm_subnet_network_security_group_association" "hub_management_nsg_association" {
  subnet_id                 = module.hubnetwork.vnet_subnets[1]
  network_security_group_id = azurerm_network_security_group.hub_mgmt_nsg.id
  depends_on = [azurerm_firewall.hub]
  // This depends on will prevent a deadlock between nsg and nic\firewall - as per open issue 
  // https://github.com/terraform-providers/terraform-provider-azurerm/issues/2489
}

resource "azurerm_subnet_network_security_group_association" "spoke_web_nsg_association" {
  subnet_id                 = module.spoke1network.vnet_subnets[0]
  network_security_group_id = azurerm_network_security_group.spoke_web_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "spoke2_web_nsg_association" {
  subnet_id                 = module.spoke2network.vnet_subnets[0]
  network_security_group_id = azurerm_network_security_group.spoke_web_nsg.id
}

// route table associations

resource "azurerm_subnet_route_table_association" "spoke1_udr_assoc" {
  subnet_id      = module.spoke1network.vnet_subnets[0]
  route_table_id = azurerm_route_table.spoke_rt_table.id
}

resource "azurerm_subnet_route_table_association" "spoke2_udr_assoc" {
  subnet_id      = module.spoke2network.vnet_subnets[0]
  route_table_id = azurerm_route_table.spoke_rt_table.id
}

// peerings

resource "azurerm_virtual_network_peering" "hubspoke1" {
  name                      = "hubspoke1"
  resource_group_name       = "${module.hubnetwork.vnet_name}-rg"
  virtual_network_name      = module.hubnetwork.vnet_name
  remote_virtual_network_id = module.spoke1network.vnet_id
}

resource "azurerm_virtual_network_peering" "spoke1hub" {
  name                      = "spoke1hub"
  resource_group_name       = "${module.spoke1network.vnet_name}-rg"
  virtual_network_name      = module.spoke1network.vnet_name
  remote_virtual_network_id = module.hubnetwork.vnet_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "hubspoke2" {
  name                      = "hubspoke2"
  resource_group_name       = "${module.hubnetwork.vnet_name}-rg"
  virtual_network_name      = module.hubnetwork.vnet_name
  remote_virtual_network_id = module.spoke2network.vnet_id
}

resource "azurerm_virtual_network_peering" "spoke2hub" {
  name                      = "spoke2hub"
  resource_group_name       = "${module.spoke2network.vnet_name}-rg"
  virtual_network_name      = module.spoke2network.vnet_name
  remote_virtual_network_id = module.hubnetwork.vnet_id
  allow_forwarded_traffic   = true
}