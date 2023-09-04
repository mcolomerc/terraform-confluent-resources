// Create ClusterAdmin service account 
locals { 
  admin_service_accounts = distinct(var.clusters.*.cluster_admin_sa)
  apps_service_accounts = distinct(var.service_accounts.*.name)
  service_accounts = concat(local.admin_service_accounts, local.apps_service_accounts)
} 
 
module "create_service_accounts" {
  for_each = toset(local.service_accounts)
  source   = "github.com/mcolomerc/terraform-confluent-iam?ref=v1.0.2"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment     = var.environment
  service_account = {
    name = each.value
    description = "Service Account ${each.value}"
  }
}
// Service Accounts - ClusterAdmin RoleBindings
module "admin_service_account_rbac" {
  for_each = { for cluster in var.clusters : "${cluster.id}/${cluster.cluster_admin_sa}" => cluster }
  source   = "github.com/mcolomerc/terraform-confluent-iam?ref=v1.0.2"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment     = var.environment
  cluster_role_bindings = {
    service_account = each.value.cluster_admin_sa
    cluster         = each.value.id
    sa_role_bindings = [{
      role = "CloudClusterAdmin"
      name     = "cluster"
    }]
  } 
  depends_on = [  
   module.create_service_accounts
  ]
} 

// Create Topics
module "topics" {
  for_each = { for cluster in var.clusters : cluster.id => cluster }
  source   = "github.com/mcolomerc/terraform-confluent-topics?ref=v1.0.0"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment = var.environment
  cluster     = each.key
  topics      = each.value.topics
  cluster_credentials = {
    api_key    = module.admin_service_account_rbac["${each.value.id}/${each.value.cluster_admin_sa}"].service_account_kafka_api_key.id
    api_secret = module.admin_service_account_rbac["${each.value.id}/${each.value.cluster_admin_sa}"].service_account_kafka_api_key.secret
  }
   depends_on = [  
    module.create_service_accounts,
    module.admin_service_account_rbac
  ]
}

locals { 
  service_accounts_map = flatten([for sa_key, sa_value in var.service_accounts: [
      for rbac_key, rbac_value in sa_value.cluster_rbac : {
        index = "${sa_value.name}-${rbac_value.cluster}"
        service_account_name = sa_value.name 
        service_account_description = sa_value.description
        cluster        = rbac_value.cluster
        sa_role_bindings = rbac_value.sa_role_bindings 
     }
    ]
  ])
}
 

// Create Service Accounts and role bindings
module "service_accounts" {
  for_each =   { for sa in local.service_accounts_map : sa.index => sa } 
  source   = "github.com/mcolomerc/terraform-confluent-iam?ref=v1.0.2"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment      = var.environment
  cluster_role_bindings = {
    service_account = each.value.service_account_name
    cluster         = each.value.cluster
    sa_role_bindings = each.value.sa_role_bindings
  }
  depends_on = [
    module.create_service_accounts,
    module.topics
  ] 
}

locals {
  links =  [ for link in var.links : {
      name = link.name 
      cluster_1 = {
        id = link.cluster_1.id
        credentials = {
          key =  module.admin_service_account_rbac["${link.cluster_1.id}/${link.cluster_1.service_account}"].service_account_kafka_api_key.id
          secret =  module.admin_service_account_rbac["${link.cluster_1.id}/${link.cluster_1.service_account}"].service_account_kafka_api_key.secret
        }
        mirrors = link.cluster_1.mirrors
      }        
      cluster_2 = {
        id = link.cluster_2.id
        credentials = {
          key =  module.admin_service_account_rbac["${link.cluster_2.id}/${link.cluster_2.service_account}"].service_account_kafka_api_key.id
          secret =  module.admin_service_account_rbac["${link.cluster_2.id}/${link.cluster_2.service_account}"].service_account_kafka_api_key.secret
        }
        mirrors = link.cluster_2.mirrors
      }        
  }]
}
 
## NETWORK SHARE
/* locals { 
    clusterList_1 = var.links[*].cluster_1.id
    clusterList_2 = var.links[*].cluster_2.id
    clusterList = concat(local.clusterList_1, local.clusterList_2)
}

// For each link in the list, get the cluster resource -- 401 Forbidden- TODO
data "confluent_kafka_cluster" "clusters" {
  for_each = toset(local.clusterList) 
  id = each.value
  environment {
    id = var.environment
  }
}
// Get Networks
locals {
  networks = [ for network in data.confluent_kafka_cluster.clusters : network.network_id ]
}
*/
// For each cluster in the list get the network id and create a network share
module "network_share" { 
   source = "github.com/mcolomerc/terraform-confluent-network-share?ref=v1.0.2"
   providers = {
    confluent = confluent.confluent_cloud 
  }
  environment = var.environment
  confluent_cloud_network_ids = var.networks
}

## CLUSTER LINKS
module "cluster_links" { 
  source = "github.com/mcolomerc/terraform-confluent-cluster-link?ref=v1.0.0"
  providers = {
    confluent = confluent.confluent_cloud 
  }
  links = [ for link in var.links : {
      name = link.name 
      cluster_1 = {
        id = link.cluster_1.id
        bootstrap_endpoint = link.cluster_1.bootstrap_endpoint
        rest_endpoint = link.cluster_1.rest_endpoint
        credentials = {
          key =  module.admin_service_account_rbac["${link.cluster_1.id}/${link.cluster_1.service_account}"].service_account_kafka_api_key.id
          secret =  module.admin_service_account_rbac["${link.cluster_1.id}/${link.cluster_1.service_account}"].service_account_kafka_api_key.secret
        }
        mirrors = link.cluster_1.mirrors
      }        
      cluster_2 = {
        id = link.cluster_2.id
        bootstrap_endpoint = link.cluster_2.bootstrap_endpoint
        rest_endpoint = link.cluster_2.rest_endpoint
        credentials = {
          key =  module.admin_service_account_rbac["${link.cluster_2.id}/${link.cluster_2.service_account}"].service_account_kafka_api_key.id
          secret =  module.admin_service_account_rbac["${link.cluster_2.id}/${link.cluster_2.service_account}"].service_account_kafka_api_key.secret
        }
        mirrors = link.cluster_2.mirrors
      }        
  }] 
}
