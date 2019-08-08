
resource "google_bigtable_instance" "bigtable-instance" {
  name          = "mybigtablenstance"
  instance_type = "DEVELOPMENT"
  cluster {
    cluster_id   = "mycluster"
    zone         = "asia-northeast1-a"
    torage_type = "HDD"
  }
}
resource "google_bigtable_table" "table" {
name          = "table"
instance_name = "${google_bigtable_instance.bigtable-instance.name}"
split_keys    =  ["a","b","c"]
}
resource "google_redis_instance" "cache" {
name           = "redishcashe"
tier           = "STANDARD_HA"
memory_size_gb = 20
location_id             = "us-central1-a"
alternative_location_id = "us-central1-a"
authorized_network = "hclblueprint-adminvpc.self_link"
  redis_version     = "REDIS_3_2"
display_name      = "mychache"
reserved_ip_range = "192.168.0.0/29"
}
resource "google_sql_database_instance" "master" {
  name = "mysqlinstance"
  database_version = "MYSQL_5_6"
  region = "us-central1"
  settings {
    tier = "db-f1-micro"
}
}
resource "google_sql_user" "users" {
  name     = "dbusershrwan"
  instance = "${google_sql_database_instance.master.name}"
  password = "shrwan123@"
}
resource "google_sql_database_instance" "master" {
  name = "myinstanceaa"
  database_version = "POSTGRES_9_6"
  region = "us-central1"
  settings {
    tier = "db-f1-micro"
}
}
resource "google_sql_user" "users" {
  name     = "dbuser"
  instance = "${google_sql_database_instance.master.name}"
  password = "shrwanawe"
}