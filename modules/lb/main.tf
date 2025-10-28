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

# Backend service uses HTTP to communicate with pods
resource "google_compute_backend_service" "backend" {
  name          = var.lb_name
  protocol      = "HTTP"
  port_name     = "http"
  timeout_sec   = 30
  health_checks = [google_compute_health_check.default.self_link]
  load_balancing_scheme = "EXTERNAL_MANAGED"
  enable_cdn    = true

  cdn_policy {
    cache_mode                   = "CACHE_ALL_STATIC"
    default_ttl                  = 300
    max_ttl                      = 600
    client_ttl                   = 600
    negative_caching             = false
    serve_while_stale            = 600
    
    cache_key_policy {
      include_host           = true
      include_protocol       = true
      include_query_string   = false
    }
  }

  backend {
    # 🟩 Expect zonal NEG self-link from GKE (global LBs need ZONAL NEGs)
    group = var.neg
    balancing_mode = "RATE"
    max_rate_per_endpoint = 100
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

resource "google_compute_global_forwarding_rule" "https_fwd" {
  name                  = "${var.name}-https-fwd"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_https_proxy.proxy.id
  port_range            = "443"
  ip_address            = google_compute_global_address.lb_ip.address
}

resource "google_compute_health_check" "default" {
  name               = "app-hc"
  check_interval_sec = 10
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = var.health_check_port
    request_path = var.health_check_path
  }
}

output "forwarding_ip" {
  value = google_compute_global_address.lb_ip.address
}
