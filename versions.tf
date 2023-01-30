#############################################################################
# Terraform Blue Prints required Versions
############################################################################# 
# 
# File: Versions required for Terraform and its providers
# Version: 1.0
# 
#############################################################################

terraform {
  required_version = ">= 0.14.00"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"                    # Azure provider version 
      #version = ">= 1.32"
      version = "~>2.43.0"
    }
    /*
    github = {
      source  = "integrations/github"                 # Github provider version
      version = "4.3.0"
    }
    */
  }
}


