variable "branch_or_sha" {
  type = string
  default = "main"
}
job "pulmap-production" {
  region = "global"
  datacenters = ["dc1"]
  node_pool = "production"
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
        {{- with nomadVar "nomad/jobs/pulmap-production" -}}
        RAILS_ENV = 'production'
        PULMAP_SECRET_KEY_BASE = '{{ .PULMAP_SECRET_KEY_BASE }}'
        PULMAP_DB = '{{ .PULMAP_DB }}'
        PULMAP_DB_HOST = '{{ .PULMAP_DB_HOST }}'
        PULMAP_DB_USERNAME = '{{ .PULMAP_DB_USERNAME }}'
        PULMAP_DB_PASSWORD = '{{ .PULMAP_DB_PASSWORD }}'
        PULMAP_SOLR_URL = '{{ .PULMAP_SOLR_URL }}'
        PULMAP_REDIS_URL = '{{ .PULMAP_REDIS_URL }}'
        PULMAP_REDIS_DB = '{{ .PULMAP_REDIS_DB }}'
        GOOGLE_CLOUD_PROJECT = '{{ .GOOGLE_CLOUD_PROJECT }}'
        GOOGLE_CLOUD_BUCKET = '{{ .GOOGLE_CLOUD_BUCKET }}'
        GOOGLE_CLOUD_CREDENTIALS = '{{ .GOOGLE_CLOUD_CREDENTIALS }}'
        PROXY_GEOSERVER_URL = '{{ .PROXY_GEOSERVER_URL }}'
        PROXY_GEOSERVER_AUTH = '{{ .PROXY_GEOSERVER_AUTH }}'
        PULMAP_ADMIN_NETIDS = '{{ .PULMAP_ADMIN_NETIDS }}'
        PULMAP_RABBIT_SERVER = '{{ .PULMAP_RABBIT_SERVER }}'
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
