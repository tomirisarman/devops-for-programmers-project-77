terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = var.zone
  endpoint  = "api.yandexcloud.kz:443"
  token     = var.yc_token
  folder_id = var.folder_id
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.us5.datadoghq.com/"
}

