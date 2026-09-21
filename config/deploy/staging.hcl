variable "branch_or_sha" {
  type = string
  default = "main"
}
job "pulmap-staging" {
  region = "global"
  datacenters = ["dc1"]
  node_pool = "staging"
  type = "service"
  group "web" {
    count = 2
    network {
      port "http" { to = 3000 }
      dns {
        servers = ["172.17.0.1", "128.112.129.209", "8.8.8.8", "8.8.4.4"]
      }
    }
    service {
      port = "http"
      name = "pulmap-staging-web"
      tags = [
        "frontend",
        "logging",
        # Enable traefik for bot protection.
        "traefik.enable=true",
        # Router 1: pulmap-staging-skip-all-mw
        # Skips middleware if it's an ajax request.
        "traefik.http.routers.pulmap-staging-skip-all-mw.rule=Header(`X-Forwarded-Host`, `maps-staging.princeton.edu`) && Header(`Sec-Fetch-Dest`, `empty`)",
        "traefik.http.routers.pulmap-staging-skip-all-mw.priority=11",
        # Redirect root searches (e.g. /?q=maps) to /catalog
        "traefik.http.routers.pulmap-staging-skip-all-mw.middlewares=append-catalog-regex@file",
        # Router 2: pulmap-staging-apply-mw
        # Applies captcha-protect middleware if it's not ajax. 
        "traefik.http.routers.pulmap-staging-apply-mw.rule=Header(`X-Forwarded-Host`, `maps-staging.princeton.edu`)",
        "traefik.http.routers.pulmap-staging-apply-mw.middlewares=append-catalog-regex@file,captcha-protect@file",
        "traefik.http.routers.pulmap-staging-apply-mw.priority=10",
        # Health checks lets Traefik keep track of down nodes and lets us monitor uptime.
        "traefik.http.services.pulmap-staging-web.loadbalancer.healthcheck.path=/health",
        "traefik.http.services.pulmap-staging-web.loadbalancer.healthcheck.interval=10s",
        "traefik.http.services.pulmap-staging-web.loadbalancer.healthcheck.timeout=2s"
      ]
      check {
        type = "http"
        port = "http"
        path = "/health.json"
        interval = "10s"
        timeout = "5s"
      }
    }
    task "webserver" {
      driver = "docker"
      config {
        image = "ghcr.io/pulibrary/pulmap:${ var.branch_or_sha }"
        ports = ["http"]
        force_pull = true
      }
      resources {
        cpu    = 1000
        memory = 500
      }
      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env = true
        change_mode = "restart"
        data = <<EOF
        {{- with nomadVar "nomad/jobs/pulmap-staging" -}}
        RAILS_ENV = 'staging'
        PULMAP_SECRET_KEY_BASE = '{{ .PULMAP_SECRET_KEY_BASE }}'
        PULMAP_DB = '{{ .PULMAP_DB }}'
        PULMAP_DB_HOST = '{{ .PULMAP_DB_HOST }}'
        PULMAP_DB_USERNAME = '{{ .PULMAP_DB_USERNAME }}'
        PULMAP_DB_PASSWORD = '{{ .PULMAP_DB_PASSWORD }}'
        PULMAP_SOLR_URL = '{{ .PULMAP_SOLR_URL }}'
        PULMAP_ADMIN_NETIDS = '{{ .PULMAP_ADMIN_NETIDS }}'
        HONEYBADGER_API_KEY = '{{ .HONEYBADGER_API_KEY }}'
        MAP_FEEDBACK_TO = '{{ .MAP_FEEDBACK_TO }}'
        OTEL_SERVICE_NAME = '{{ .OTEL_SERVICE_NAME }}'
        OTEL_EXPORTER_OTLP_ENDPOINT = '{{ .OTEL_EXPORTER_OTLP_ENDPOINT }}'
        OTEL_EXPORTER_OTLP_INSECURE = '{{ .OTEL_EXPORTER_OTLP_INSECURE }}'
        OTEL_EXPORTER_OTLP_TRACES_PROTOCOL = '{{ .OTEL_EXPORTER_OTLP_TRACES_PROTOCOL }}'
        {{- end -}}
        EOF
      }
    }
  }
}
