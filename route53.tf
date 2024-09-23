resource "aws_route53_health_check" "route53_health_check" {
  depends_on = [aws_cloudwatch_metric_alarm.route53_health_alarm]

  health_check_config {
    alarm_identifier {
      name   = aws_cloudwatch_metric_alarm.route53_health_alarm.alarm_name
      region = var.region
    }

    insufficient_data_health_status = "Unhealthy"
    type                            = "CLOUDWATCH_METRIC"
  }

  tags = {
    Name = terraform.workspace
  }
}
