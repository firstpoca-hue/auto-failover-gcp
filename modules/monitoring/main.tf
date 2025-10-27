resource "google_monitoring_alert_policy" "gke_down" {
  display_name = "GKE Nodes Down"
  combiner = "OR"

  conditions {
    display_name = "GKE Node Down"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/up\" AND resource.type=\"gce_instance\""
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      duration        = "300s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
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