// Create ClusterAdmin service account 

// Create Service Accounts - ClusterAdmin
module "admin_service_account" {
  for_each = { for cluster in var.clusters : cluster.id => cluster }
  source   = "github.com/mcolomerc/terraform-confluent-iam"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment     = var.environment
  service_account = each.value.cluster_admin_sa
  cluster         = each.key
  sa_role_bindings = [{
    role = "ClusterAdmin"
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
  credentials = {
    api_key    = module.admin_service_account.service_account_credentials.id
    api_secret = module.admin_service_account.service_account_credentials.secret
  }
}

// Create Service Accounts
module "service_accounts" {
  for_each = { for sa in var.service_accounts : sa.name => sa }
  source   = "github.com/mcolomerc/terraform-confluent-iam"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment      = var.environment
  service_account  = each.key
  cluster          = each.value.cluster_rbac.cluster
  sa_role_bindings = each.value.cluster_rbac.sa_role_bindings
}

