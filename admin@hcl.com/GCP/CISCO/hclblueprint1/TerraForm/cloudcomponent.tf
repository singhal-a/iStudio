
resource "google_bigtable_instance" "bigtable-instance1" {
  name          = "mybigtablenstance"
  instance_type = "DEVELOPMENT"
  cluster {
    cluster_id   = "mycluster"
    zone         = "asia-northeast1-a"
    storage_type = "HDD"
  }
}
resource "google_bigtable_table" "table" {
  name          = "table"
  instance_name = "${google_bigtable_instance.bigtable-instance1.name}"
  split_keys    =  ["a","b","c"]
}
resource "google_redis_instance" "cache1" {
  name           = "redishcashe"
  tier           = "STANDARD_HA"
  memory_size_gb = 20
  location_id             = "us-central1-a"
  alternative_location_id = "us-central1-b"
  redis_version     = "REDIS_3_2"
  display_name      = "mychache"
  reserved_ip_range = "192.168.0.0/29"
}
resource "google_sql_database_instance" "master1" {
  name = "mysqlserver"
  database_version = "MYSQL_5_6"
  region = "us-central1"
  settings {
    tier = "db-f1-micro"
  }
}
resource "google_sql_user" "users1" {
  name     = "dbusershrwan"
  instance = "${google_sql_database_instance.master1.name}"
  password = "shrwan123@"
}
resource "google_sql_database_instance" "master2" {
  name = "mypostgrateserver"
  database_version = "POSTGRES_9_6"
  region = "us-central1"
  settings {
    tier = "db-f1-micro"
  }
}
resource "google_sql_user" "users2" {
  name     = "dbuser"
  instance = "${google_sql_database_instance.master2.name}"
  password = "shrwanawe"
}
resource "google_storage_bucket" "bucket-store1" {
  name     = "myucket1234"
  location = "us-central1"
  storage_class="REGIONAL"
}
resource "google_cloudfunctions_function" "gcpfunction1" {
  name = "myfunction2"
  description = "test"
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
  name = "mytopic1"
  project = "softwarization-net"
}
resource "google_pubsub_subscription" "subscrioptionpull1" {
  name  = "mysuc1"
  topic = "${google_pubsub_topic.topic1.name}"
  message_retention_duration = "1000s"
  retain_acked_messages = true
  ack_deadline_seconds = 600
  expiration_policy {
    ttl = "300000.5s"
  }
}