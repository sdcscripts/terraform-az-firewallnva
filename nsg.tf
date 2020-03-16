resource "azurerm_resource_group" "nsg_rg" {
  name     = var.hub_nsg_rg_name
  location = var.location
}

resource "azurerm_network_security_group" "hub_mgmt_nsg" {
  name                = var.hub_mgmt_nsg_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
}

resource "azurerm_network_security_group" "spoke_web_nsg" {
  name                = var.spoke_web_nsg_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = azurerm_resource_group.nsg_rg.name
}

resource "azurerm_network_security_rule" "nsg_hub_rules" {
  name                          = lookup(var.hub_mgmt_rules[count.index], "name", "defaultruleplaceholder")
  priority                      = lookup(var.hub_mgmt_rules[count.index], "priority", 64999)
  direction                     = lookup(var.hub_mgmt_rules[count.index], "direction", "Inbound")
  access                        = lookup(var.hub_mgmt_rules[count.index], "access", "Deny")
  protocol                      = lookup(var.hub_mgmt_rules[count.index], "protocol", "udp")
  source_port_range             = lookup(var.hub_mgmt_rules[count.index], "source_port_ranges", "8888")
  source_address_prefix         = lookup(var.hub_mgmt_rules[count.index], "source_address_prefix", "8.8.8.8/32")
  destination_port_range        = lookup(var.hub_mgmt_rules[count.index], "destination_port_ranges", "8888")
  destination_address_prefix    = lookup(var.hub_mgmt_rules[count.index], "destination_address_prefix", "8.8.8.8/32")
  description                   = lookup(var.hub_mgmt_rules[count.index], "description", "defaultplaceholder")
  resource_group_name           = azurerm_resource_group.nsg_rg.name
  network_security_group_name   = azurerm_network_security_group.hub_mgmt_nsg.name
  count                         = length(var.hub_mgmt_rules)
}

resource "azurerm_network_security_rule" "nsg_spoke_rules" {
  name                          = lookup(var.spoke_web_rules[count.index], "name", "defaultruleplaceholder")
  priority                      = lookup(var.spoke_web_rules[count.index], "priority", 64999)
  direction                     = lookup(var.spoke_web_rules[count.index], "direction", "Inbound")
  access                        = lookup(var.spoke_web_rules[count.index], "access", "Deny")
  protocol                      = lookup(var.spoke_web_rules[count.index], "protocol", "udp")
  source_port_range             = lookup(var.spoke_web_rules[count.index], "source_port_ranges", "8888")
  source_address_prefix         = lookup(var.spoke_web_rules[count.index], "source_address_prefix", "8.8.8.8/32")
  destination_port_range        = lookup(var.spoke_web_rules[count.index], "destination_port_ranges", "8888")
  destination_address_prefix    = lookup(var.spoke_web_rules[count.index], "destination_address_prefix", "8.8.8.8/32")
  description                   = lookup(var.spoke_web_rules[count.index], "description", "defaultplaceholder")
  resource_group_name           = azurerm_resource_group.nsg_rg.name
  network_security_group_name   = azurerm_network_security_group.spoke_web_nsg.name
  count                         = length(var.spoke_web_rules)
}