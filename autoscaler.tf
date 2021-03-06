resource "google_compute_region_autoscaler" "autoscaler" {
  name   = "autoscaler"
  region = "us-east1"
  target = google_compute_region_instance_group_manager.web-group.id

  autoscaling_policy {
    max_replicas    = 10
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}