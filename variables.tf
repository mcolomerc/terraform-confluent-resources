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

