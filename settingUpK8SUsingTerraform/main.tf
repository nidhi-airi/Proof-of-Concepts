# Setting up providers 
provider "google" {
 project     = "${var.gcp_project_id}" 
 credentials = "${file("${var.credentials}")}" #file that contains cluster credentials
 region      = "${var.region}"   # region assosciated 
}


# data google_container_cluster
data "google_container_cluster" "primary" {
  name     = "${var.env_name}-gke"
  location = var.region
}

# creating vpc network
resource "google_compute_network" "vpc" {
  name                    = "${var.env_name}-vpc"
  auto_create_subnetworks = "false"
}

# creating Subnet assosciated with vpc
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.env_name}-subnet"
  region        = var.region
  network       = "${google_compute_network.vpc.name}"
  ip_cidr_range = var.cidr_range
}


# Kubernetes Cluster Creation for the Vpc network
resource "google_container_cluster" "primary" {
  name     = "${var.env_name}-gke"
  location = var.region
  project  = "${var.gcp_project_id}"
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = var.nodecount
  network    = "${google_compute_network.vpc.name}"
  subnetwork = "${google_compute_subnetwork.subnet.name}"
}

# Node pool creation
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  project     = "${var.gcp_project_id}"
  node_count = var.nodecount

  node_config {
    preemptible  = true
    machine_type = var.machine
  }
}

#setting up credentials
resource "null_resource" "get-credentials" {

 depends_on = [
   google_container_cluster.primary,
  ] 
 provisioner "local-exec" {
   command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region=${var.region} --project=${var.gcp_project_id}"
 }
}

// In order to create the services and deployements for cluster creation we need to uncomment the below lines

provider "kubernetes" {
  config_path    = "~/.kube/config"
 
  host               = "https://${data.google_container_cluster.primary.endpoint}" 
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

# #service creation
resource "kubernetes_service" "service-testing" {
  metadata {
    name = "service-test"
  }
   spec {
    port {
      port        = var.ports 
      target_port = var.targetport
    }
    type = "LoadBalancer"
  }
   depends_on = [
      null_resource.get-credentials,
   ]
}
# #pod creation assosciated with service

resource "kubernetes_pod" "pod-test" {
  metadata {
    name = "test-nginx"
    labels = {
     App = "nginx"
    } 
  }
  spec {
     container {
      image = var.imagename
      name  = "nginx"
      port {
        container_port = var.containerport
      }
    }
  } 
}
