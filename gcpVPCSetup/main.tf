provider "google" {
 project     = "${var.gcp_project}"
 credentials = "${file("${var.credentials}")}"
 region      = "${var.region}"
}
// Create VPC
resource "google_compute_network" "vpc" {
 name                    = "${var.name}-vpc"
 auto_create_subnetworks = "false"
}


// VPC firewall configuration
resource "google_compute_firewall" "firewall" {
  name    = "${var.name}-firewall"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
// Create Subnet
resource "google_compute_subnetwork" "subnet" { 
 count = "${length(var.subnet_name)}"
 name          = "${var.subnet_name[count.index]}"
 ip_cidr_range = "${var.subnet_cidr[count.index]}"
 network       = "${var.name}-vpc"
 region        = "${var.region}"
  depends_on = [
   google_compute_network.vpc,
  ]
}

//Create Router
resource "google_compute_router" "router" {
  name    = "test-router"
  region  =  "${var.region}"
  network =  "${var.name}-vpc"

  bgp {
    asn = 64514
  }
}

//Create NAT Gateway
resource "google_compute_router_nat" "nat" {
  name                               = "vpc-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}