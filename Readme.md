# Manage Confluent Cloud cluster resources 

## Topics

```hcl 
clusters = [
  {
    id = "lkc-"
    topics = [
      {
        name       = "topic-3"
        partitions = 3
        config = {
          "delete.retention.ms" = "86400000"
        }
      },
      {
        name       = "topic-6"
        partitions = 6
        config = {
          "cleanup.policy"      = "delete" 
          "delete.retention.ms" = "86410000"
        }
      }
    ]
  }
]
```

## RBAC 

```hcl
# Service accounts 
service_accounts = [
  {
    name        = "mcolomer-dev1"
    description = "Service account for dev1"
    cluster_rbac = [{
        environment = "env-"
        cluster     = "lkc-" 
        sa_role_bindings = [
        {
            role     = "DeveloperRead"
            resource = "topic"
            name     = "topic-3"
        },
        {
            role     = "DeveloperWrite"
            resource = "topic"
            name     = "topic-6"
        }
        ]
    }]
  },
````

--> Private Netowking

Requires access to the data plane. 