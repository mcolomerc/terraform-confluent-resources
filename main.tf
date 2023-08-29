// Create ClusterAdmin service account 

// Create Service Accounts - ClusterAdmin
module "admin_service_account" {
  for_each = { for cluster in var.clusters : cluster.cluster_admin_sa => cluster }
  source   = "github.com/mcolomerc/terraform-confluent-iam"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment     = var.environment
  service_account = {
    name = each.key
    description = "Cluster ${each.value.id} Admin Service Account"
  }
  cluster         = each.value.id
  sa_role_bindings = [{
    role = "CloudClusterAdmin"
    name     = "cluster"
  }]
}

// Create Topics
module "topics" {
  for_each = { for cluster in var.clusters : cluster.id => cluster }
  source   = "github.com/mcolomerc/terraform-confluent-topics"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment = var.environment
  cluster     = each.key
  topics      = each.value.topics
  cluster_credentials = {
    api_key    = module.admin_service_account[each.value.cluster_admin_sa].service_account_kafka_api_key.id
    api_secret = module.admin_service_account[each.value.cluster_admin_sa].service_account_kafka_api_key.secret
  }
}

locals { 
  service_accounts_map = flatten([for sa_key, sa_value in var.service_accounts: [
      for rbac_key, rbac_value in sa_value.cluster_rbac : {
        index = sa_key
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
  source   = "github.com/mcolomerc/terraform-confluent-iam"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment      = var.environment
  service_account  = { 
    name = each.value.service_account_name
    description = each.value.service_account_description 
 }

  cluster = each.value.cluster
  sa_role_bindings = each.value.sa_role_bindings
   
}

