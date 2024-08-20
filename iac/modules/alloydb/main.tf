resource "google_alloydb_instance" "default" {
  cluster       = google_alloydb_cluster.default.name
  instance_id   = var.instance_id
  instance_type = "PRIMARY"

  machine_config {
    cpu_count = var.instance_cpu_count
  }

  database_flags = {
    "password.enforce_complexity"                         = "on"
    "password.enforce_password_does_not_contain_username" = "on"
  }
}

resource "google_compute_global_address" "private_ip_alloc" {
  project       = var.project_id
  name          = "${var.cluster_id}-network-alloc"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = var.network_id
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

resource "google_alloydb_cluster" "default" {
  project    = var.project_id
  cluster_id = var.cluster_id
  location   = var.cluster_region

  network = var.network_id

  initial_user {
    user     = var.username
    password = var.password
  }
}
