output "service_accounts_map" {
    value = local.service_accounts_map
}

output "cluster_admin" {
  value = {
    for k, t in module.admin_service_account : t.service_account.id => { 
      description = t.service_account.description
      display_name = t.service_account.display_name 
    }
  }
}

output "service_accounts" {
  value = {
    for k, t in module.service_accounts : t.service_account.id => {
      description = t.service_account.description
      display_name = t.service_account.display_name 
    }
  }
}

output "rolebindings" {
    value = values(module.service_accounts).*.service_account_kafka_role_bindings  
}

output "topics" {
 value = { 
    for k, t in module.topics : k => t.topics
  }
}
 