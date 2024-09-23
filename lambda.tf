locals {
  protocols = ["TCP", "HTTP", "HTTPS"]
}

# Define Lambda functions based on protocol
resource "aws_lambda_function" "health_check" {
  count = contains(local.protocols, var.protocol) ? 1 : 0

  filename         = "${var.protocol == "TCP" ? "tcp.zip" : var.protocol == "HTTP" ? "http.zip" : "https.zip"}"
  function_name    = "${terraform.workspace}"
  role             = var.lambda_execution_role_arn
  handler          = "index.lambda_handler"
  runtime          = "python3.11"
  timeout          = 10
  source_code_hash = filebase64sha256("path_to_lambda_zips/${var.protocol == "TCP" ? "tcp.zip" : var.protocol == "HTTP" ? "http.zip" : "https.zip"}")

  environment {
    variables = {
      cfprotocol           = var.protocol
      cfport               = tostring(var.port)
      cfResourceIPaddress  = var.resource_ip_address
      cfstackname          = terraform.workspace
      cfpath               = var.path
    }
  }

  vpc_config {
    security_group_ids = [var.security_group_ids]
    subnet_ids         = var.subnets
  }

  tags = {
    Name = terraform.workspace
  }
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "health_check_rule" {
  count = contains(local.protocols, var.protocol) ? 1 : 0

  name                = terraform.workspace
  description         = "Route53 Health Check"
  schedule_expression = "rate(1 minute)"
  is_enabled          = true
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "health_check_target" {
  count = contains(local.protocols, var.protocol) ? 1 : 0

  rule      = aws_cloudwatch_event_rule.health_check_rule[count.index].name
  target_id = "${var.protocol}Target"
  arn       = aws_lambda_function.health_check[count.index].arn
}

# Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  count = contains(local.protocols, var.protocol) ? 1 : 0

  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.health_check[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.health_check_rule[count.index].arn
}
