output "route53_health_check_id" {
  description = "ID of the Route53 Health Check."
  value       = aws_route53_health_check.route53_health_check.id
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function."
  value       = aws_lambda_function.health_check[*].arn
}

output "cloudwatch_alarm_arn" {
  description = "ARN of the CloudWatch Alarm."
  value       = aws_cloudwatch_metric_alarm.route53_health_alarm.arn
}
