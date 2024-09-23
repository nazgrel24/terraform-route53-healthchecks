locals {
  alarm_dimensions = {
    TCP   = [{ Name = "TCP Health Check", Value = "TCP Health Check" }]
    HTTP  = [{ Name = "HTTP Health Check", Value = "HTTP Health Check" }]
    HTTPS = [{ Name = "HTTPS Health Check", Value = "HTTPS Health Check" }]
  }
}

resource "aws_cloudwatch_metric_alarm" "route53_health_alarm" {
  alarm_name          = "${var.protocol}-${terraform.workspace}-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "${var.protocol}: ${terraform.workspace} (Health Check for resource ${var.resource_ip_address})"
  namespace           = "Route53PrivateHealthCheck"
  period              = 60
  statistic           = "Minimum"
  threshold           = 1
  alarm_description   = "Alarm for Route53 Health Check"
  datapoints_to_alarm = 2
  treat_missing_data  = "breaching"

  dimensions = {
    for d in local.alarm_dimensions[var.protocol] : d.Name => d.Value
  }

  tags = {
    Name = terraform.workspace
  }
}

output "alarm_name" {
  description = "Name of the CloudWatch Alarm."
  value       = aws_cloudwatch_metric_alarm.route53_health_alarm.alarm_name
}
