variable "rgname" {
  description = "Resource Group to deploy VM into"
}
variable "location" {
  description = "Resource Group location to deploy to"
}

variable "vmname" {
  description = "Name of the VM"
}
variable "subnetid" {
  description = "ID of the subnet to use for the VM deployment"
}

variable "vmsize" {
  description = "size of VM"
  default = "Standard_DS2_v2"
}

variable "vmpassword" {
  description = "Password for the VM"
}

variable "adminusername"{
   description = "Name of the admin account"
}
