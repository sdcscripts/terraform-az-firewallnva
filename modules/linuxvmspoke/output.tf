output "vmnicip" {
  description = "the ip address of the vm"  
  value = azurerm_network_interface.myterraformnic.private_ip_address
}

output "id" {
  description = "id of the provisioned vm"
  value       = azurerm_virtual_machine.myterraformvm.id
}