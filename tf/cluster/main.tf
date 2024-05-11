resource "google_container_cluster" "voting_cluster" {
  name               = "my-vpc-native-cluster"
  location           = var.zone
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network_id
  subnetwork = var.subnetwork_id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = var.subnetwork_secondary_ip_range
  }

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.voting_cluster.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
  }
}