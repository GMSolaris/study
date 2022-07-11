terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
   }


backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "myagkikh"
    region     = "ru-central1"
    key        = "./prod/state.tfstate"
    access_key = "***"
    secret_key = "***"


    skip_region_validation      = true
    skip_credentials_validation = true
 }
}

provider "yandex" {
  token     = "****"
  cloud_id  = "b1gm57mphkmqkn0a6nh2"
  folder_id = "b1glcqqf4u1eoejacm8k"
  zone      = "ru-central1-a"
}



