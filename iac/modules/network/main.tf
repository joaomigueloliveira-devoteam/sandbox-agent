resource "google_compute_network" "default" {
  project                 = var.project_id
  name                    = var.name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  project       = var.project_id
  name          = var.subnet_name
  network       = google_compute_network.default.name
  region        = var.region
  ip_cidr_range = var.subnet_cidr_range
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_vpc_access_connector" "connector" {
  name          = var.vpc_access_connector.name
  region        = var.vpc_access_connector.region
  ip_cidr_range = var.vpc_access_connector.ip_cidr_range
  network       = google_compute_network.default.name
}
