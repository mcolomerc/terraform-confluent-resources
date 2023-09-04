environment = "env-zmz2zd"


# Cluster resources [topics]
clusters = [
  {
    id = "lkc-mkqvww"
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
    id = "lkc-5m2732"
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

# Service accounts 
service_accounts = [
  {
    name        = "mcolomer-dev1"
    description = "Service account for dev1"
    cluster_rbac = [{ 
      cluster     = "lkc-mkqvww"
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
      cluster     = "lkc-5m2732"
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
      cluster     = "lkc-mkqvww"
      sa_role_bindings = [
        {
          role     = "DeveloperRead"
          resource = "topic"
          name     = "topic-1-1"
        }
      ]
    },
    { 
      cluster     = "lkc-5m2732"
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

networks = ["n-6me4k4", "n-p2j31l"]

links = [
  {
    name = "bid-link"  
    cluster_1 = {
      id = "lkc-mkqvww"
      bootstrap_endpoint = "lkc-mkqvww.dom4g2l2ypr.eu-central-1.aws.confluent.cloud:9092"
      rest_endpoint = "https://lkc-mkqvww.dom4g2l2ypr.eu-central-1.aws.confluent.cloud:443"
      service_account = "mcolomer-admin" 
      mirrors = ["topic-2-1"]
    },
    cluster_2= {
      id = "lkc-5m2732"
      bootstrap_endpoint = "lkc-5m2732.dommp7518ew.eu-west-1.aws.confluent.cloud:9092"
      rest_endpoint = "https://lkc-5m2732.dommp7518ew.eu-west-1.aws.confluent.cloud:443"
      service_account = "mcolomer-admin" 
      mirrors = ["topic-1-1"]
    } 
  }
]