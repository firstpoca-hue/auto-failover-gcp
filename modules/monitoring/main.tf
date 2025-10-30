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
  type         = "webhook_tokenauth"
  labels = {
    url = "https://${var.function_region}-${var.project_id}.cloudfunctions.net/${var.function_name}"
  }
  sensitive_labels {
    auth_token = var.webhook_auth_token
  }
}

# resource "google_monitoring_alert_policy" "gke_down" {
#   display_name = "GKE Down"
#   combiner     = "OR"

#   conditions {
#     display_name = "NEG unhealthy"
#     condition_threshold {
#       filter          = var.metric_filter  # your metric
#       comparison      = "COMPARISON_EQ"
#       threshold_value = 0
#       duration        = "60s"
#       trigger { count = 1 }
#     }
#   }

#   notification_channels = [google_monitoring_notification_channel.email.id]
# }