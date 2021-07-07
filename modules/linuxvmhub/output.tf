output "vmnicip" {
  description = "the ip address of the vm"
  value       = azurerm_network_interface.myterraformnic.private_ip_address
}

output "public_ip_dns_name" {
  description = "fqdn to connect to the vm provisioned."
  value       = azurerm_public_ip.myterraformpublicip.fqdn
}
