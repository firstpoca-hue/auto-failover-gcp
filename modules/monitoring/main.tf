resource "random_password" "webhook_token" {
  length  = 32
  special = false
}

resource "google_monitoring_alert_policy" "app_down" {
  display_name = "Application Down"
  combiner = "OR"
 
  conditions {
    display_name = "GKE Ingress 5xx Errors"
    condition_threshold {
      filter = "metric.type=\"loadbalancing.googleapis.com/https/backend_response_count\" AND resource.type=\"gce_backend_service\" AND metric.label.response_code_class=\"5xx\""
      # filter          = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" AND resource.type=\"https_lb_rule\" AND metric.label.response_code_class=\"5xx\""
      comparison      = "COMPARISON_GT"
      threshold_value = 3
      duration        = "60s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
 
  notification_channels = [
    google_monitoring_notification_channel.email.id,
    google_monitoring_notification_channel.webhook.id
  ]
  enabled               = true
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "Alerts Email"
  type         = "email"
  labels = { 
  email_address = var.alert_email 
  }
}

resource "google_monitoring_notification_channel" "webhook" {
  display_name = "Failover Webhook"
  type         = "webhook_basicauth"
  enabled      = true

  labels = {
    url = "https://us-central1-hot-cold-drp.cloudfunctions.net/failover-trigger"
    username = "webhook"
  }

  sensitive_labels {
    password = random_password.webhook_token.result
  }
}

output "webhook_token" {
  value = random_password.webhook_token.result
  sensitive = true
}

