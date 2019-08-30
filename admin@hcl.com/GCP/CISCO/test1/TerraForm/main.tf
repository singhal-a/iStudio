
provider "google" {
  credentials = "${file("C:/Shrwan/Project/iStudio/iSudioBackend/TerraForm/iSudioFiles/softwarization-net.json")}"
  project  = "${var.gcp_project}"
  region   = "${var.gcp_region}"  
}





