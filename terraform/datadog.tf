resource "datadog_synthetics_test" "http_test" {
  name = "My Health Check"
  type = "api"

  subtype = "http"
  request_definition {
    method = "GET"
    url    = "http://redmine76.space/"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = 200
  }

  locations = ["aws:us-east-1"]

  options_list {
    tick_every   = 3600
    monitor_name = "http-test-monitor"
    monitor_options {
      renotify_interval    = 300
      renotify_occurrences = 3
    }
  }

  tags = [
    "env:prod",
    "team:devops"
  ]

  message = "Health check failed for http://redmine76.space/ @devops-team"
  status  = "live"
}
