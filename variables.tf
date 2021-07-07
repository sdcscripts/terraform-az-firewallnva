variable "location" {
  description = "Location for all resources"
}

variable "networkrgname" {
  description = "Location for all resources"
}

variable "computergname" {
  description = "Location for all resources"
}

variable "hub_nsg_rg_name" {
  description = "Name of NSG RG"
}
variable "hub_mgmt_nsg_name" {
  description = "Name of NSG"
}

variable "spoke_web_nsg_name" {
  description = "Name of NSG"
}

variable "vm_admin_user" {
  description = "Username for Virtual Machines"
}
variable "vm_admin_pwd" {
  description = "Password for Virtual Machines"
}

variable "vm_size" {
  description = "Size of the VMs"
}

variable "hub_vm_hostname" {
  description = "Hostname of hub VM "
}
variable "spoke1_vm_hostname" {
  description = "Hostname of spoke1 VM "
}

variable "spoke2_vm_hostname" {
  description = "Hostname of spoke2 VM "
}

variable "hub_vnet_name" {
  description = "Name of Hub vnet"
}
variable "spoke1_vnet_name" {
  description = "Name of spoke 1 "
}

variable "spoke2_vnet_name" {
  description = "Name of spoke 2"
}

variable "hub_mgmt_rules" {
  description = "Open SSH to Hub management network"
}

variable "spoke_web_rules" {
  description = "Open SSH to Hub management network"
}

variable "rt_table_rg_name" {
  description = "Open SSH to Hub management network"
}
variable "spoke_rt_table_name" {
  description = "Name of custom route table to attach to spoke networks"
}

