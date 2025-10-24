# 🟩 modules/lb/main.tf

resource "google_compute_global_address" "lb_ip" {
  name = "${var.name}-ip"
}

# 🟩 Ensure valid PEMs exist (generated via OpenSSL)
resource "google_compute_ssl_certificate" "self_signed" {
  name        = "${var.name}-self-signed"
  private_key = file("${path.module}/certs/private.key")
  certificate = file("${path.module}/certs/certificate.crt")
}

# 🟩 Use HTTPS protocol since LB proxy is HTTPS
resource "google_compute_backend_service" "backend" {
  name          = var.lb_name
  protocol      = "HTTPS"                       # 🟩 changed from HTTP → HTTPS
  port_name     = "https"                       # 🟩 changed
  timeout_sec   = 30
  health_checks = [google_compute_health_check.default.self_link]

  backend {
    # 🟩 Expect zonal NEG self-link from GKE (global LBs need ZONAL NEGs)
    group = var.neg
  }
}

resource "google_compute_url_map" "urlmap" {
  name            = "${var.name}-urlmap"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_https_proxy" "proxy" {
  name             = "${var.name}-proxy"
  url_map          = google_compute_url_map.urlmap.id
  ssl_certificates = [google_compute_ssl_certificate.self_signed.id]
}

resource "google_compute_global_forwarding_rule" "fwd" {
  name                  = "${var.name}-fwd"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_https_proxy.proxy.id
  port_range            = "443"
  ip_address            = google_compute_global_address.lb_ip.address
}

resource "google_compute_health_check" "default" {
  name               = "app-hc"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port         = var.health_check_port
    request_path = var.health_check_path
  }
}

output "forwarding_ip" {
  value = google_compute_global_address.lb_ip.address
}
