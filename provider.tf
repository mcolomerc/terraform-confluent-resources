# Configure the Confluent Cloud Provider
terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent" 
      version = "~>1.51.0"
      configuration_aliases = [ confluent.confluent_cloud ]
    }
     
  } 
  required_version = ">= 1.3.0"
} 

provider "confluent" { 
  alias = "confluent_cloud" 
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}