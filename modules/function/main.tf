data "google_secret_manager_secret_version" "my_pat_secret" {
  secret  = var.github_pat_secret
  version = "8"
  fetch_secret_data = true

}

resource "google_pubsub_topic" "failover" {
  name = "failover-notify"
}

resource "google_pubsub_subscription" "failover_sub" {
  name  = "failover-subscription"
  topic = google_pubsub_topic.failover.id
}

# resource "google_cloudfunctions_function" "failover_fn" {
#   name = "failover-trigger"
#   runtime = "python311"
#   entry_point = "trigger_failover"
#   available_memory_mb = 256
#   source_archive_bucket = var.source_bucket
#   source_archive_object = var.source_object
#   event_trigger {
#     event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
#     resource   = google_pubsub_topic.failover.id
#   }
# }

# resource "google_secret_manager_secret" "github_pat" {
#   secret_id = var.github_secret_name
#   replication {
#   auto = true 
# }
# }


resource "google_cloudfunctions2_function" "failover_trigger" {
  name        = "failover-trigger"
  location    = var.region
  description = "Triggered by Cloud Monitoring alert via Pub/Sub, initiates GitHub Actions failover."
 
  build_config {
    runtime     = "python311"
    entry_point = "failover_trigger"
 
    source {
      storage_source {
        bucket = google_storage_bucket.function_source.name
        object = google_storage_bucket_object.function_zip.name
      }
    }
  }
 
  service_config {
    available_memory   = "256M"
    timeout_seconds    = 60
    max_instance_count = 1
    environment_variables = {
      GITHUB_REPO = var.github_repo
      GITHUB_TOKEN_SECRET = data.google_secret_manager_secret_version.my_pat_secret.secret_data
    }
  }
 
  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.failover.id
    retry_policy   = "RETRY_POLICY_RETRY"
  }
}


resource "google_storage_bucket" "function_source" {
  name     = "${var.project_id}-function-source"
  location = var.region
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}"
  output_path = "${path.module}/function.zip"
}

resource "google_storage_bucket_object" "function_zip" {
  name   = "function.zip"
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.function_zip.output_path
}

resource "google_monitoring_notification_channel" "pubsub_channel" {
  display_name = "Failover Pub/Sub Channel"
  type         = "pubsub"
  labels = {
    topic = google_pubsub_topic.failover.id
  }
}

resource "google_monitoring_alert_policy" "gke_pod_zero_alert" {
  display_name = "GKE Pods Zero - Trigger Failover"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "Pods = 0 for 10 minutes"
    condition_monitoring_query_language {
      query = file("${path.module}/gke_pod_zero_alert.mql")
      duration = "600s" # 10 minutes
      trigger {
        count = 1
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.pubsub_channel.id]

  documentation {
    content   = "Triggered when primary region pods = 0 for 10m. Sends Pub/Sub to invoke Cloud Function and trigger GitHub Actions failover pipeline."
    mime_type = "text/markdown"
  }
}