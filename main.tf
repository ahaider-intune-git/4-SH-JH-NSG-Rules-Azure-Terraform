##################################################################################
# Terraform SMC Automation LHD Foundation Resources creation based on the 
# Refrence Architecture and Requirements 
# NSG Module
##################################################################################
# 
# LHD         :     Justice Health (JH)
# File        :     Main File
# eh Admins   :     Nane
# pgm         :     SwDCR
# Version     :     v.1.0
##################################################################################


provider "azurerm" {
    features {}
}

locals {
    nsg_meta_data = csvdecode(file("./Files/NSG-Master.csv")) # CSV file path of the meta data
}

module "Network_Security_Rules"{
    source = "./NSG-Module"
    for_each = {for i in local.nsg_meta_data : i.Ref => i }
    resource_group_name                             = trimspace(each.value.ResourceGroupName)
    network_security_group_name                     = trimspace(each.value.NSGName)
    nsg_file                                        = trimspace(each.value.FileName)
}
