resource "google_compute_region_instance_group_manager" "web-group" {
  name                      = "web-group"
  base_instance_name        = "web-group"
  region                    = "us-east1"
  distribution_policy_zones = ["us-east1-b", "us-east1-c", "us-east1-d"]

  version {
    instance_template = google_compute_instance_template.web-template.id
  }

  target_size = 3

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 30
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}
