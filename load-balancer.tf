resource "google_compute_global_forwarding_rule" "forwarding" {
  name       = "forwarding"
  target     = google_compute_target_http_proxy.target_proxy.id
  port_range = "80"
}

resource "google_compute_target_http_proxy" "target_proxy" {
  name    = "target-proxy"
  url_map = google_compute_url_map.urlmap.id
}


resource "google_compute_url_map" "urlmap" {
  name            = "urlmap"
  default_service = google_compute_backend_service.be_service.id
}

resource "google_compute_backend_service" "be_service" {
  name          = "lb-be"
  port_name     = "http"
  protocol      = "HTTP"
  timeout_sec   = 10
  health_checks = [google_compute_http_health_check.health_check.id]
  backend {
    group = google_compute_region_instance_group_manager.web-group.instance_group
  }
}

resource "google_compute_http_health_check" "health_check" {
  name               = "hc"
  request_path       = "/"
  check_interval_sec = 20
  timeout_sec        = 10
}
