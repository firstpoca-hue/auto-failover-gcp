resource "google_pubsub_topic" "failover" {
  name = "failover-notify"
}

resource "google_cloudfunctions_function" "failover_fn" {
  name = "failover-trigger"
  runtime = "python311"
  entry_point = "trigger_failover"
  available_memory_mb = 256
  source_archive_bucket = var.source_bucket
  source_archive_object = var.source_object
  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.failover.id
  }
}

resource "google_secret_manager_secret" "github_pat" {
  secret_id = var.github_secret_name
  replication {
  auto {} 
}
}

output "failover_function_name" {
  value = google_cloudfunctions_function.failover_fn.name
}

output "pubsub_topic_name" {
  value = google_pubsub_topic.failover.name
}