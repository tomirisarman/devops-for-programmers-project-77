variable "yc_token" {
  sensitive = true
}
variable "folder_id" {
  sensitive = true
}
variable "image_id" {
  sensitive = true
}
variable "security_group_id" {
  sensitive = true
}
variable "ssh_public_key" {
  sensitive = true
}
variable "zone" {}
variable "remote_backend_bucket" {}
variable "remote_backend_key" {}
variable "remote_backend_access_key" {
  sensitive = true
}
variable "remote_backend_secret" {
  sensitive = true
}
variable "datadog_api_key" {
  sensitive = true
}
variable "datadog_app_key" {
  sensitive = true
}
variable "db_name" {
  sensitive = true
}
variable "db_username" {
  sensitive = true
}
variable "db_password" {
  sensitive = true
}
