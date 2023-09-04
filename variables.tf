# Confluent Cloud Credentials  
variable "confluent_cloud_api_key" {
  type        = string
  description = "Confluent Cloud API KEY. export TF_VAR_confluent_cloud_api_key=\"API_KEY\""
}

variable "confluent_cloud_api_secret" {
  type        = string
  description = "Confluent Cloud API KEY. export TF_VAR_confluent_cloud_api_secret=\"API_SECRET\""
}

variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

# Service accounts and role bindings list
variable "service_accounts" {
  type = list(object({
    name        = string
    description = string
    cluster_rbac = list(object({
      cluster = string
      sa_role_bindings = list(object({
        role     = string
        resource = string
        name     = string
      })) 
    }))
  }))
} 


# Cluster List - Resources
variable "clusters" {
  type = list(object({
    id            = string
    cluster_admin_sa = string
    topics = list(object({
      name       = string
      partitions = number
      config     = map(string)
    }))
  }))
}

variable "networks" {
    type = list(string)
}

# Confluent Cloud Kafka clusters to link
variable "links" {
  type = list(object({
    name     = string
    cluster_1 = object({
      id            = string
      bootstrap_endpoint = string
      rest_endpoint = string
      service_account = string
      mirrors = list(string)
    })
    cluster_2 = object({
      id            = string
      bootstrap_endpoint = string
      rest_endpoint = string
      service_account = string
      mirrors = list(string)
    })
    })
  )
}
