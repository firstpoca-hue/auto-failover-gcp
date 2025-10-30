variable "project_id" {}
variable "alert_email"{}
variable "function_region" {
  default = "us-central1"
}
variable "function_name" {
  default = "failover-trigger"
}
variable "webhook_auth_token" {
  default = "change-me-if-using-tokenauth"
}