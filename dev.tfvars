environment = "env-zmz2zd"


# Cluster resources [topics]
clusters = [
  {
    id = "lkc-0j2yjp"
    cluster_admin_sa = "mcolomer-admin"  # Create ClusterAdmin role binding for this service account
    topics = [
      {
        name       = "topic-1-1"
        partitions = 3
        config = {
          "delete.retention.ms" = "86400000"
        }
      },
      {
        name       = "topic-1-2"
        partitions = 6
        config = {
          "cleanup.policy"      = "delete"
          "delete.retention.ms" = "86410000"
        }
      }
    ]
  }, { 
    id = "lkc-0jzjk5"
    cluster_admin_sa = "mcolomer-admin"  # Create ClusterAdmin role binding for this service account
    topics = [
      {
        name       = "topic-2-1"
        partitions = 3
        config = {
          "delete.retention.ms" = "86400000"
        }
      } 
    ]
  }
] 

# Service accounts and role bindings
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
          name     = "topic-1-1"
        },
        {
          role     = "DeveloperWrite"
          resource = "topic"
          name     = "topic-1-2"
        }
      ]
    },
    { 
      cluster     = "lkc-0jzjk5"
      sa_role_bindings = [
        {
          role     = "DeveloperRead"
          resource = "topic"
          name     = "topic-2-1"
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
          name     = "topic-1-1"
        }
      ]
    },
    { 
      cluster     = "lkc-0jzjk5"
      sa_role_bindings = [
        {
          role     = "DeveloperWrite"
          resource = "topic"
          name     = "topic-2-1"
        } 
      ]
    }]
  }
]
