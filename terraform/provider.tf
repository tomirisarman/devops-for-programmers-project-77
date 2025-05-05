terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.kz"
    }
    bucket = "yc-hexlet-state"
    region = "kz1-a"
    key    = "terraform/terraform.tfstate"
    access_key = var.remote_backend_access_key
    secret_key = var.remote_backend_secret
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  zone = var.zone
  endpoint = "api.yandexcloud.kz:443"
  token = var.yc_token
  folder_id = var.folder_id
}
