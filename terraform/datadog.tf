resource "datadog_monitor" "http_check_alive" {
  name = "App Liveness Check - HTTP"
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

  notify_no_data    = false
  renotify_interval = 60
  evaluation_delay  = 30
  no_data_timeframe = 2
  include_tags      = true

  #   options {
  #     notify_no_data = false
  #     thresholds {
  #       warning  = 1
  #       critical = 0
  #     }
  #   }
}
