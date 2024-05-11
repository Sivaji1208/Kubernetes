terraform {
  required_version = ">=0.12"

  backend "azurerm" {
    resource_group_name = "NetworkWatcherRG"
    storage_account_name  = "terraformstateravi"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"    
  }

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.77.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "aws" {
  region = "us-east-1"
}