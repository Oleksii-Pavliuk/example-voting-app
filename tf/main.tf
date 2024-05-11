# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}


provider "google" {
  project = "decoded-vision-418200"
  region  = "us-west1"
  zone  = "us-west1-a"
}

module "networking" {
  source = "./networking"
  network_name = "voting-network"
  subnetwork_name = "voting-subnetwork"
  region  = "us-west1"
}


module "cluster" {
  source = "./cluster"
  name = "voting-cluster"
  region  = "us-west1"
  zone = "us-west1-a"
  network_id = module.networking.network_id
  subnetwork_id = module.networking.subnetwork_id
  subnetwork_secondary_ip_range = module.networking.subnetwork_secondary_ip_range
}
resource "google_container_cluster" "voting_cluster" {
  name               = "my-vpc-native-cluster"
  location           = "us-west1"
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = module.networking.network_id
  subnetwork = module.networking.subnetwork_id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = module.networking.subnetwork_secondary_ip_range
  }
}

provider "kubernetes" {
  host  = "https://${module.cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    module.cluster.cluster_ca_certificate,
  )
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}