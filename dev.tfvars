environment = "env-zmz2zd"


# Cluster resources [topics]
clusters = [
  {
    id = "lkc-0j2yjp"
    cluster_admin_sa = "mcolomer-admin"  # Create ClusterAdmin role binding for this service account
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

# Service accounts 
service_accounts = [
  {
    name        = "mcolomer-dev1"
    description = "Service account for dev1"
    cluster_rbac = [{ 
      cluster     = "lkc-0j2yjp"
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
  {
    name        = "mcolomer-dev2"
    description = "Service account for dev2"
    cluster_rbac = [{ 
      cluster     = "lkc-0j2yjp"
      sa_role_bindings = [
        {
          role     = "DeveloperRead"
          resource = "topic"
          name     = "topic-6"
        }
      ]
    }]
  }
]
