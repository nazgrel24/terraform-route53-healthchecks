resource "aws_security_group" "lambda_sg" {
  name        = "${var.protocol}-${terraform.workspace}-sg"
  description = "${var.protocol}: ${terraform.workspace}"
  vpc_id      = var.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}"
  }
}

output "lambda_security_group_id" {
  description = "Security Group ID for Lambda functions."
  value       = aws_security_group.lambda_sg.id
}
