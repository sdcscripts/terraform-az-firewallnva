resource "azurerm_resource_group" "rt_table" {
  name                          = var.rt_table_rg_name
  location                      = var.location
}

resource "azurerm_route_table" "spoke_rt_table" {
  name                          = var.spoke_rt_table_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rt_table.name
}

resource "azurerm_route" "route" {
  name                          = "default-route-entry"
  resource_group_name           = azurerm_resource_group.rt_table.name
  route_table_name              = azurerm_route_table.spoke_rt_table.name
  address_prefix                = "0.0.0.0/0"
  next_hop_type                 = "VirtualAppliance"
  next_hop_in_ip_address        = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}