variable "branch_or_sha" {
  type = string
  default = "main"
}
# Job for scheduled rake tasks
job "pulmap-staging-periodic" {
  region = "global"
  datacenters = ["dc1"]
  node_pool = "staging"
  type = "batch"
  periodic {
    crons = ["0 22 * * *"]
    time_zone = "America/New_York"
    prohibit_overlap = true
  }
  group "database-cleanup" {
    count = 1
    network {
      dns {
        servers = ["172.17.0.1", "128.112.129.209", "8.8.8.8", "8.8.4.4"]
      }
    }
    task "delete-old-records" {
      driver = "docker"
      config {
        image = "ghcr.io/pulibrary/pulmap:${ var.branch_or_sha }"
        command = "./bin/rake"
        args = ["blacklight:delete_old_searches", "devise_guests:delete_old_guest_users"]
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
        OTEL_SERVICE_NAME = '{{ .OTEL_SERVICE_NAME }}'
        OTEL_EXPORTER_OTLP_ENDPOINT = "http://{{ env "attr.unique.network.ip-address" }}:4318"
        OTEL_EXPORTER_OTLP_INSECURE = '{{ .OTEL_EXPORTER_OTLP_INSECURE }}'
        OTEL_EXPORTER_OTLP_TRACES_PROTOCOL = '{{ .OTEL_EXPORTER_OTLP_TRACES_PROTOCOL }}'
        ENTRA_CLIENT_ID = 'f05f4c00-ff98-466c-bbfb-9603eecdd6ac'
        ENTRA_CLIENT_SECRET = '{{ .PULMAP_ENTRA_SECRET }}'
        ENTRA_REDIRECT_URI = 'https://maps-staging.princeton.edu/users/auth/openid_connect/callback'
        {{- end -}}
        EOF
      }
    }
  }
}
