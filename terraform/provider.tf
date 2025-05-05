terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = var.zone
  endpoint = "api.yandexcloud.kz:443"
  token = var.yc_token
  folder_id = var.folder_id
}
