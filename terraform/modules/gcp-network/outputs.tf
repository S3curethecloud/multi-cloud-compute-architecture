output "network_self_link" {
  value = google_compute_network.vpc.self_link
}

output "public_subnet_self_link" {
  value = google_compute_subnetwork.public_a.self_link
}

output "network_name" {
  value = google_compute_network.vpc.name
}
