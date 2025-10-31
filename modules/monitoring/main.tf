resource "random_password" "webhook_token" {
  length  = 32
  special = false
}

resource "google_monitoring_alert_policy" "app_down" {
  display_name = "Application Down"
  combiner = "OR"

  conditions {
    display_name = "Backend Service Unhealthy"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/backend_request_count\" AND resource.type=\"gce_backend_service\" AND metric.label.response_code_class=\"5xx\""
      comparison      = "COMPARISON_GT"
      threshold_value = 5
      duration        = "120s"
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
  type         = "webhook_basic"
  enabled      = true

  labels = {
    url = "https://us-central1-hot-cold-drp.cloudfunctions.net/failover-trigger"
  }
}

output "webhook_token" {
  value = random_password.webhook_token.result
  sensitive = true
}

