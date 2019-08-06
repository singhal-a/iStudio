
provider "google" {
  credentials = "${file("C:/Shrwan/Project/iStudio/iSudioBackend/TerraForm/iSudioFiles/softwarization-net.json")}"
  project  = "hcltech\shrwank"
  region   = "${var.gcp_region}"  
}

resource "google_compute_network" "gcp_vpc" {
  name                    = "test1-adminvpc-network"
  project                 = "hcltech\shrwank"
  auto_create_subnetworks = false
}




resource "google_container_node_pool" "kubernetes-cluster-node-pool" { 
 name       = "kubernetes-nodes" 
 project    = "hcltech\shrwank" 
 cluster    = "${google_container_cluster.kubernetes-cluster.name}" 
 location   = "asia-east1-a" 
 node_count = "2" 
 node_config { 
  machine_type = "n1-standard-4"     
  oauth_scopes = ["compute-rw","storage-full","pubsub","logging-write","service-control","service-management","monitoring","bigquery", 
  "cloud-platform","cloud-source-repos","cloud-source-repos-ro","datastore","service-control","service-management","taskqueue"] 
  labels {  for = "ReferenceArchitecture" } 
  tags = ["cisco", "test1-admin"] 
 } 
 autoscaling { 
  min_node_count = "2" 
  max_node_count = "10" 
 } 
 management { 
  auto_repair  = true 
 } 
} 
 
resource "google_container_cluster" "kubernetes-cluster" {
 name               = "test1-admin-kubernetes"
 project            = "hcltech\shrwank" 
 location           = "asia-east1-a"
 remove_default_node_pool = true
 initial_node_count = 1 
 network            = "${google_compute_network.gcp_vpc.name}" 
 subnetwork         = "${google_compute_subnetwork.gcp_subnet.name}" 
 enable_legacy_abac = true 
 node_locations = ["asia-east1-b"] 
} 
