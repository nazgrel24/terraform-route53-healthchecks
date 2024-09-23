resource "aws_iam_role" "lambda_execution_role" {
  name = "${terraform.workspace}-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${terraform.workspace}-lambda-execution-role"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${terraform.workspace}-lambda-policy"
  description = "IAM policy for Lambda functions."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams",
          "cloudwatch:PutMetricData",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "lambda:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

output "lambda_execution_role_arn" {
  description = "ARN of the IAM role for Lambda functions."
  value       = aws_iam_role.lambda_execution_role.arn
}
