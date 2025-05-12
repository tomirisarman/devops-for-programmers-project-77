data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    endpoints = {
      s3 = "https://storage.yandexcloud.kz"
    }
    bucket     = var.remote_backend_bucket
    region     = var.zone
    key        = var.remote_backend_key
    access_key = var.remote_backend_access_key
    secret_key = var.remote_backend_secret

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}