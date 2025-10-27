resource "google_monitoring_alert_policy" "app_down" {
  display_name = "Application Down"
  combiner = "OR"

  conditions {
    display_name = "Load Balancer Error Rate High"
    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" AND resource.type=\"https_lb_rule\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "60s"
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.id]
  enabled               = true
}


resource "google_monitoring_notification_channel" "email" {
  display_name = "Alerts Email"
  type         = "email"
  labels = { 
  email_address = var.alert_email 
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