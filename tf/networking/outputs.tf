output "network_id" {
  value = google_compute_network.custom.id
}
output "subnetwork_id" {
  value = google_compute_subnetwork.custom.id
}

output "subnetwork_secondary_ip_range" {
  value = google_compute_subnetwork.custom.secondary_ip_range.0.range_name
}