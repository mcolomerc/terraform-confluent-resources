output "service_accounts_map" {
    value = local.service_accounts_map
}

output "create_service_accounts" {
  value = values(module.create_service_accounts).*.service_account 
} 

output "rolebindings" {
    value = values(module.service_accounts).*.service_account_kafka_role_bindings  
}

output "topics" {
 value = { 
    for k, t in module.topics : k => t.topics
  }
} 

output "admin_service_accounts_keys" {
  value = values(module.admin_service_account_rbac).*.service_account_kafka_api_key.id 
  sensitive = true
}

output "admin_service_accounts_set" {
  value = local.admin_service_accounts
}

output "apps_service_accounts_set" {
  value = local.apps_service_accounts
}
output "local_service_accounts_" {
  value = local.service_accounts
}
 