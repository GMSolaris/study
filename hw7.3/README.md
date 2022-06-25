Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

    Создадим бэкэнд в S3 (необязательно, но крайне желательно).

    Инициализируем проект и создаем воркспейсы.
	```
            11:55:52 myagkikh@netology:~/netology/terraform$ terraform workspace new stage
            Created and switched to workspace "stage"!
            
            You're now on a new, empty workspace. Workspaces isolate their state,
            so if you run "terraform plan" Terraform will not see any existing state
            for this configuration.
            11:56:43 myagkikh@netology:~/netology/terraform$ terraform workspace new prod
            Created and switched to workspace "prod"!
            
            You're now on a new, empty workspace. Workspaces isolate their state,
            so if you run "terraform plan" Terraform will not see any existing state
            for this configuration.
            11:56:48 myagkikh@netology:~/netology/terraform$ terraform workspace list
              default
            * prod
              stage
            
            11:56:51 myagkikh@netology:~/netology/terraform$ terraform workspace new dev
            Created and switched to workspace "dev"!

            You're now on a new, empty workspace. Workspaces isolate their state,
            so if you run "terraform plan" Terraform will not see any existing state
            for this configuration.
            11:57:47 myagkikh@netology:~/netology/terraform$ terraform workspace list
              default
            * dev
              prod
              stage
 ```           



    Прод:
``` 
 11:57:54 myagkikh@netology:~/netology/terraform$ terraform workspace select prod
    Switched to workspace "prod".
```
    
	
Вывод terraform workspace select prod:
```
    11:57:54 myagkikh@netology:~/netology/terraform$ terraform workspace select prod
            Switched to workspace "prod".
            11:58:02 myagkikh@netology:~/netology/terraform$ terraform workspace list
              default
              dev
            * prod
              stage
```            

        
 
Содержимое s3.tf:

```
        provider "aws" {
                region = "us-west-2"
        }
        resource "aws_s3_bucket" "bucket" {
          bucket = "netology-bucket-${terraform.workspace}"
          acl    = "private"
          tags = {
            Name        = "Bucket1"
            Environment = terraform.workspace
          }
        }
```


Вывод Комманд:
```
        12:19:06 myagkikh@netology:~/netology/terraform$ terraform init
        
        Initializing the backend...
        
        Initializing provider plugins...
        - Reusing previous version of hashicorp/aws from the dependency lock file
        - Using previously-installed hashicorp/aws v3.32.0
        
        Terraform has been successfully initialized!
        
        You may now begin working with Terraform. Try running "terraform plan" to see
        any changes that are required for your infrastructure. All Terraform commands
        should now work.
        
        If you ever set or change modules or backend configuration for Terraform,
        rerun this command to reinitialize your working directory. If you forget, other
        commands will detect it and remind you to do so if necessary.
        
		12:19:12 myagkikh@netology:~/netology/terraform$ terraform plan
        
        An execution plan has been generated and is shown below.
        Resource actions are indicated with the following symbols:
          + create
        
        Terraform will perform the following actions:
        
          # aws_s3_bucket.bucket will be created
          + resource "aws_s3_bucket" "bucket" {
              + acceleration_status         = (known after apply)
              + acl                         = "private"
              + arn                         = (known after apply)
              + bucket                      = "netology-bucket-prod"
              + bucket_domain_name          = (known after apply)
              + bucket_regional_domain_name = (known after apply)
              + force_destroy               = false
              + hosted_zone_id              = (known after apply)
              + id                          = (known after apply)
              + region                      = (known after apply)
              + request_payer               = (known after apply)
              + tags                        = {
                  + "Environment" = "prod"
                  + "Name"        = "Bucket1"
                }
              + website_domain              = (known after apply)
              + website_endpoint            = (known after apply)
        
              + versioning {
                  + enabled    = (known after apply)
                  + mfa_delete = (known after apply)
                }
            }
        
        Plan: 1 to add, 0 to change, 0 to destroy.
        
        ------------------------------------------------------------------------
        
        Note: You didn't specify an "-out" parameter to save this plan, so Terraform
        can't guarantee that exactly these actions will be performed if
        "terraform apply" is subsequently run.
        
        12:19:22 myagkikh@netology:~/netology/terraform$ terraform workspace list
          default
          dev
        * prod
          stage
        
        12:19:35 myagkikh@netology:~/netology/terraform$ terraform apply
        
        An execution plan has been generated and is shown below.
        Resource actions are indicated with the following symbols:
          + create
        
        Terraform will perform the following actions:
        
          # aws_s3_bucket.bucket will be created
          + resource "aws_s3_bucket" "bucket" {
              + acceleration_status         = (known after apply)
              + acl                         = "private"
              + arn                         = (known after apply)
              + bucket                      = "netology-bucket-prod"
              + bucket_domain_name          = (known after apply)
              + bucket_regional_domain_name = (known after apply)
              + force_destroy               = false
              + hosted_zone_id              = (known after apply)
              + id                          = (known after apply)
              + region                      = (known after apply)
              + request_payer               = (known after apply)
              + tags                        = {
                  + "Environment" = "prod"
                  + "Name"        = "Bucket1"
                }
              + website_domain              = (known after apply)
              + website_endpoint            = (known after apply)
        
              + versioning {
                  + enabled    = (known after apply)
                  + mfa_delete = (known after apply)
                }
            }
        
        Plan: 1 to add, 0 to change, 0 to destroy.
        
        Do you want to perform these actions in workspace "prod"?
          Terraform will perform the actions described above.
          Only 'yes' will be accepted to approve.
        
          Enter a value: yes
        
        aws_s3_bucket.bucket: Creating...
        aws_s3_bucket.bucket: Still creating... [10s elapsed]
        aws_s3_bucket.bucket: Still creating... [20s elapsed]
        aws_s3_bucket.bucket: Creation complete after 21s [id=netology-bucket-prod]
        
        Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
        12:20:19 myagkikh@netology:~/netology/terraform$ 
		
```		

Содержимое s3.tf:
```
provider "aws" {
        region = "us-west-2"
}

locals {
  web_instance_count_map = {
  stage = 1
  prod = 2
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "netology-bucket-${count.index}-${terraform.workspace}"
  acl    = "private"
  tags = {
    Name        = "Bucket ${count.index}"
    Environment = terraform.workspace
  }
  count = local.web_instance_count_map[terraform.workspace]
}
```


Содержимое s3.tf:
```
provider "aws" {
        region = "us-west-2"
}

locals {
  web_instance_count_map = {
  stage = 1
  prod = 2
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = "netology-bucket-${count.index}-${terraform.workspace}"
  acl    = "private"
  tags = {
    Name        = "Bucket ${count.index}"
    Environment = terraform.workspace
  }
  count = local.web_instance_count_map[terraform.workspace]
}

locals {
  backets_ids = toset([
    "e1",
    "e2",
  ])
}
resource "aws_s3_bucket" "bucket_e" {
  for_each = local.backets_ids
  bucket = "netology-bucket-${each.key}-${terraform.workspace}"
  acl    = "private"
  tags = {
    Name        = "Bucket ${each.key}"
    Environment = terraform.workspace
  }
}
```

