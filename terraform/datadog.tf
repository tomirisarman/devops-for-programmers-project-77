resource "datadog_monitor" "http_check_alive" {
  name = "Health check"
  type = "service check"

  query = "\"http.can_connect\".by(\"host\").last(2).count_by_status()"

  message = <<EOM
App liveness check failed on {{host.name}}.
Please investigate the application instance.
EOM

  tags = [
    "env:production",
    "app:liveness",
  ]

  monitor_thresholds {
    warning           = 1
    warning_recovery  = 1
    critical          = 2
    critical_recovery = 2
  }
}
