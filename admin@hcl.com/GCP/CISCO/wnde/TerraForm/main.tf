
provider "google" {
  credentials = "${file("C:/Shrwan/Project/iStudio/iSudioBackend/TerraForm/iSudioFiles/softwarization-net.json")}"
  project  = "softwarization-net"
  region   = "us-central1"  
}

resource "google_compute_network" "gcp_vpc" {
  name                    = "wnde-adminvpc-network"
  project                 = "softwarization-net"
  auto_create_subnetworks = false
}
resource "google_compute_route" "gcp_route1" { 
 name        = "routeone" 
 project     = "softwarization-net" 
 dest_range  = "0.0.0.0/0"
 network     = "${google_compute_network.gcp_vpc.name}" 
 next_hop_gateway = "default-internet-gateway" 
 priority    = 100 
} 

resource "google_compute_firewall" "gcp_firewall1" { 
 name    = "webfirewall" 
 network = "${google_compute_network.gcp_vpc.name}" 
 priority = 1000 
 direction = "INGRESS" 
 source_ranges = ["0.0.0.0/0"] 
 allow { 
  protocol = "tcp" 
  ports    = ["80","8080","1000-2000"] 
  } 
} 

resource "google_compute_subnetwork" "gcp_subnet1" { 
 name             = "subnet" 
 ip_cidr_range    = "10.127.0.0/20" 
 network          = "${google_compute_network.gcp_vpc.name}" 
 region           = "us-central1" 
 private_ip_google_access = false 
 enable_flow_logs = false 
} 

resource "google_container_node_pool" "kubernetes-cluster-node-pool1" { 
 name       = "kubernetes-nodes" 
 project    = "softwarization-net" 
 cluster    = "${google_container_cluster.kubernetes-cluster1.name}" 
 location   = "us-central1-a" 
 node_count = "2" 
 node_config { 
  machine_type = "n1-standard-4"     
  oauth_scopes = ["compute-rw","storage-full","pubsub","logging-write","service-control","service-management","monitoring","bigquery", 
  "cloud-platform","cloud-source-repos","cloud-source-repos-ro","datastore","service-control","service-management","taskqueue"] 
  labels {  for = "ReferenceArchitecture" } 
  tags = ["cisco", "wnde-admin"] 
 } 
 autoscaling { 
  min_node_count = "1" 
  max_node_count = "10" 
 } 
 management { 
  auto_repair  = true 
 } 
} 
 
resource "google_container_cluster" "kubernetes-cluster1" {
 name               = "wnde-admin-kubernetes"
 project            = "softwarization-net" 
 location           = "us-central1-a"
 remove_default_node_pool = true
 initial_node_count = 1 
 network            = "${google_compute_network.gcp_vpc.name}" 
 subnetwork         = "${google_compute_subnetwork.gcp_subnet1.name}" 
 enable_legacy_abac = true 
 node_locations = ["us-central1-b"] 
} 

resource "google_compute_instance" "vm_instance1" {
 name         = "myfirstm1"
 machine_type = "n1-standard-1"
 zone         = "us-central1-a"
 tags         =  ["webfirewall"]
 boot_disk {
  initialize_params {
   image = "debian-cloud/debian-9"
   size = "500"
   type = "pd-standard"
  }
 }
 network_interface {
  subnetwork  = "${google_compute_subnetwork.gcp_subnet1.name}" 

  access_config {}
 }
}