resource "google_monitoring_alert_policy" "app_down" {
  display_name = "Application Down"
  combiner = "OR"

  conditions {
    display_name = "Application Pod Restarts High"
    condition_threshold {
      filter          = "metric.type=\"kubernetes.io/container/restart_count\" AND resource.type=\"k8s_container\" AND resource.labels.container_name=\"web-app\""
      comparison      = "COMPARISON_GT"
      threshold_value = 3
      duration        = "300s"
      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.id,
    google_monitoring_notification_channel.pubsub.id
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

resource "google_monitoring_notification_channel" "pubsub" {
  display_name = "Failover Trigger"
  type         = "pubsub"
  labels = {
    topic = "projects/hot-cold-drp/topics/failover-notify"
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