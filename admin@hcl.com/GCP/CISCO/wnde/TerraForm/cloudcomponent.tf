
resource "google_cloudfunctions_function" "gcpfunction1" {
  name = "wnde_function"
  description = "wnde function"
  project = "softwarization-net"
  runtime = "python37"
  available_memory_mb = 256
  region = "us-central1"
  timeout = 540
  trigger_http = true
  source_archive_bucket = "wnde"
  source_archive_object = "wnde.zip"
  entry_point = "processpcap_pubsub"
}
resource "google_pubsub_topic" "topic1" {
  name = "wnde"
  project = "softwarization-net"
}
resource "google_pubsub_subscription" "subscrioptionpull1" {
  name  = "gcf-wnde_function-wnde"
  topic = "${google_pubsub_topic.topic1.name}"
  message_retention_duration = "1000s"
  retain_acked_messages = true
  ack_deadline_seconds = 600
  expiration_policy {
    ttl = "300000.5s"
  }
}