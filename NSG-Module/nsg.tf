##################################################################################
# Module to add the NSG Rules to Terraform
##################################################################################
# 
# LHD           :     Health Entity
# Module        :     Network Security Group Rules from CSV
# Version       :     v.1.0
# he Admins     : 
# Team          :     SwDCR      
# Dev           :     Satish
# Repo          :     Master
##################################################################################

data "azurerm_subscription" "current" {

}
locals {
  network_security_group_rules = csvdecode(file("./Files/${var.nsg_file}")) # CSV file path refereing to the rules
  
}

# Create the NSG Rules 
# **************************************************************
resource "azurerm_network_security_rule" "nsgrule" {

  for_each                                        = { for asg in local.network_security_group_rules : asg.name => asg }
  name                                            = each.value.name
  description                                     = each.value.description
  priority                                        = each.value.priority
  direction                                       = each.value.direction
  access                                          = each.value.access
  protocol                                        = each.value.protocol
  
  source_port_range                               = each.value.source_port_range != "" ? each.value.source_port_range : null
  source_port_ranges                              = each.value.source_port_ranges != "" ? formatlist("%s",split(",",each.value.source_port_ranges)) : null 

  destination_port_range                          = each.value.destination_port_range != "" ? each.value.destination_port_range : null  
  destination_port_ranges                         = each.value.destination_port_ranges!= ""? formatlist("%s",split(",",each.value.destination_port_ranges)) : null
    
  source_address_prefix                           = each.value.source_address_prefix != "" ? each.value.source_address_prefix : null
  source_address_prefixes                         = each.value.source_address_prefixes != "" ? formatlist("%s",split(",",each.value.source_address_prefixes)) : null 

  destination_address_prefix                      = each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null
  destination_address_prefixes                    = each.value.destination_address_prefixes != "" ?  formatlist("%s",split(",",each.value.destination_address_prefixes)) : null
  
  source_application_security_group_ids           = each.value.source_application_security_group_ids != "" ? formatlist("%s/resourceGroups/%s/providers/Microsoft.Network/applicationSecurityGroups/%s",data.azurerm_subscription.current.id,each.value.resource_group_name,split(",",each.value.source_application_security_group_ids)) : null
  destination_application_security_group_ids      = each.value.destination_application_security_group_ids != "" ? formatlist("%s/resourceGroups/%s/providers/Microsoft.Network/applicationSecurityGroups/%s",data.azurerm_subscription.current.id,each.value.resource_group_name,split(",",each.value.destination_application_security_group_ids)) : null                                                                                                                     

  resource_group_name                             = var.resource_group_name
  network_security_group_name                     = var.network_security_group_name 
 
}