resource "random_password" "webhook_token" {
  length  = 32
  special = false
}

resource "google_monitoring_alert_policy" "app_down" {
  display_name = "Application Down"
  combiner = "OR"

  conditions {
    display_name = "GKE Cluster Down"
    condition_threshold {
      filter          = "metric.type=\"container.googleapis.com/container/up\" AND resource.type=\"k8s_container\""
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      duration        = "300s"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
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

