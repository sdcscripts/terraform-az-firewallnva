resource "random_id" "randomidfirewall" {

  byte_length = 4
}

resource "azurerm_public_ip" "firewall" {
  name                = "firewall_pip"
  location            = var.location
  resource_group_name = module.hubnetwork.vnet_rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "firewallpip-${random_id.randomidfirewall.hex}"
}

resource "azurerm_firewall" "hub" {
  name                = "hub_firewall"
  location            = var.location
  resource_group_name = module.hubnetwork.vnet_rg_name

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = module.hubnetwork.vnet_subnets[0]
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
  depends_on = [module.hubmanagementvm, module.linuxvmspoke1, module.linuxvmspoke2]
  // The firewall seems to slow down the destroy process for all these objects. approx 66% speed up to allow hub to destroy first using this depends on statement
}

resource "azurerm_firewall_network_rule_collection" "rulecollection" {
  name                = "Allow_ssh_communications_between_spokes"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = module.hubnetwork.vnet_rg_name
  priority            = 100
  action              = "Allow"

  rule {
    name = "spoke1-spoke2"

    source_addresses = [
      module.spoke1network.subnet_prefixes[0]
    ]

    destination_ports = [
      "22", "80",
    ]

    destination_addresses = [
      module.spoke2network.subnet_prefixes[0]
    ]

    protocols = [
      "TCP"
    ]
  }

  rule {
    name = "spoke2-spoke1"

    source_addresses = [
      module.spoke2network.subnet_prefixes[0]
    ]

    destination_ports = [
      "22", "80",
    ]

    destination_addresses = [
      module.spoke1network.subnet_prefixes[0]
    ]

    protocols = [
      "TCP"
    ]
  }
}
