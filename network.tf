resource "google_compute_network" "vpc" {
  name                    = "vpc-main"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "usnet" {
  name          = "usnet"
  region        = "us-east1"
  ip_cidr_range = "192.168.10.0/24"
  network       = google_compute_network.vpc.self_link
}

resource "google_compute_firewall" "fw-web" {
  name    = "fw-web"
  network = google_compute_network.vpc.self_link
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}