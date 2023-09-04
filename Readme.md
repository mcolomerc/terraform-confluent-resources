# Manage Confluent Cloud cluster resources 

Manage:
 - Service accounts 
 - Topics 
 - Role bindings 
 - Cluster Links
 
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
```

## Links 

```hcl

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
```


## Private Networking

Requires access to the data plane. 

Check resources managed by Terraform: 

* Role Bindings: 

CloudClusterAdmin:

```bash
confluent iam rbac role-binding list --role CloudClusterAdmin --current-environment --cloud-cluster lkc-0j2yjp

    Principal    |      Name      | Email  
-----------------+----------------+--------
  User:sa-wj31pw | mcolomer-admin |        
```

* Cluster API KEYS: 

```bash
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

```bash
confluent kafka topic list

   Name    
-----------
  topic-3  
  topic-6  
```

* Cluster Links 

```bash 
 confluent kafka cluster list
  Current |     ID     |               Name               |   Type    | Provider |    Region    | Availability | Status  
----------+------------+----------------------------------+-----------+----------+--------------+--------------+---------
          | lkc-5m2732 | mcolomer-standard-inventory_dev2 | DEDICATED | aws      | eu-west-1    | multi-zone   | UP      
  *       | lkc-mkqvww | mcolomer-standard-inventory_dev1 | DEDICATED | aws      | eu-central-1 | multi-zone   | UP     
```
  
```bash
confluent kafka link list
    Name   | Source Cluster | Destination Cluster | State  | Error | Error Message  
-----------+----------------+---------------------+--------+-------+----------------
  bid-link |                |                     | ACTIVE |       |                

```

```bash
 confluent kafka mirror list --link bid-link
  Link Name | Mirror Topic Name | Source Topic Name | Mirror Status | Status Time (ms) | Num Partition | Max Per Partition Mirror Lag  
------------+-------------------+-------------------+---------------+------------------+---------------+-------------------------------
  bid-link  | topic-2-1         | topic-2-1         | ACTIVE        |    1693846658778 |             3 |                            0 
``` 
 
```bash 
confluent kafka cluster use lkc-5m2732
Set Kafka cluster "lkc-5m2732" as the active cluster for environment "env-zmz2zd".
```

```bash
confluent kafka mirror list --link bid-link
  Link Name | Mirror Topic Name | Source Topic Name | Mirror Status | Status Time (ms) | Num Partition | Max Per Partition Mirror Lag  
------------+-------------------+-------------------+---------------+------------------+---------------+-------------------------------
  bid-link  | topic-1-1         | topic-1-1         | ACTIVE        |    1693846658911 |             3 |                            0  