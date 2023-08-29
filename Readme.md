# Manage Confluent Cloud cluster resources 

Manage:

- Service accounts 
- Topics 
- Role bindings 

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

## Private Networking

Requires access to the data plane. 

Check resources managed by Terraform: 

* Role Bindings: 

CloudClusterAdmin:

```
confluent iam rbac role-binding list --role CloudClusterAdmin --current-environment --cloud-cluster lkc-0j2yjp

    Principal    |      Name      | Email  
-----------------+----------------+--------
  User:sa-wj31pw | mcolomer-admin |        
```

* Cluster API KEYS: 

```
confluent api-key list --resource lkc-0j2yjp 

  Current |       Key        |          Description           |   Owner   |    Owner Email    | Resource Type |  Resource  |       Created         
----------+------------------+--------------------------------+-----------+-------------------+---------------+------------+-----------------------
          | 7NSEKBOHPXAR7FGK | Kafka API Key that is owned by | sa-kxmkz2 | <service account> | kafka         | lkc-0j2yjp | 2023-08-29T14:04:02Z  
          |                  | mcolomer-dev1 service account  |           |                   |               |            |                       
          | JJECG2AWA52RHI2I | Kafka API Key that is owned by | sa-56xqnn | <service account> | kafka         | lkc-0j2yjp | 2023-08-29T14:04:02Z  
          |                  | mcolomer-dev2 service account  |           |                   |               |            |                       
          | TD6NUB7RVNAZQJYB | Kafka API Key that is owned by | sa-wj31pw | <service account> | kafka         | lkc-0j2yjp | 2023-08-29T14:04:02Z  
          |                  | mcolomer-admin service account |           |                   |               |            |                       
```


* Topics 

```
confluent kafka topic list

   Name    
-----------
  topic-3  
  topic-6  
```
