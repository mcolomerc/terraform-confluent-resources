variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

# Service accounts list
variable service_accounts {
    type = list(object({
        name = string
        description = string
    })) 
} 


# Cluster List 
variable "clusters" {
    type = list(object({
      id = string
      topics = list(object ({
        name = string
        partitions = number
        config = map(string)
      }))
       sa_role_bindings = list(object ({
        name = string
        partitions = number
        config = map(string)
      }))
    })) 
}

