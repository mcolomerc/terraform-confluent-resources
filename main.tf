
// Create Topics
module "topics" {
  for_each = { for cluster in var.clusters : cluster.id => cluster }
  source = "github.com/mcolomerc/terraform-confluent-topics"
  providers = {
    confluent = confluent.confluent_cloud
  }
  environment = var.environment
  cluster = each.key
  topics = each.value.topics 
}

// Create Service Accounts
module "service_accounts" {
  for_each = { for sa in var.service_accounts : sa.name => sa }
  source = "github.com/mcolomerc/terraform-confluent-iam"
  providers = {
     confluent = confluent.confluent_cloud
  }
  environment = var.environment
  service_account = each.key
  cluster_rbac =  each.value.cluster_rbac
}

