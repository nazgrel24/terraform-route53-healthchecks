provider "aws" {
  region = var.region
}

# Optional: Define Terraform backend, state locking, etc., if needed.

module "security_groups" {
  source = "./security_groups.tf"
}

module "iam" {
  source = "./iam.tf"
}

module "lambda" {
  source = "./lambda.tf"
  protocol             = var.protocol
  resource_ip_address  = var.resource_ip_address
  port                 = var.port
  path                 = var.path
  subnets              = var.subnets
  vpc                  = var.vpc
  lambda_execution_role_arn = module.iam.lambda_execution_role_arn
  security_group_ids   = module.security_groups.lambda_security_group_id
}

module "cloudwatch" {
  source = "./cloudwatch.tf"
  protocol                = var.protocol
  resource_ip_address     = var.resource_ip_address
  lambda_function_arn     = module.lambda.function_arn
}

module "route53" {
  source = "./route53.tf"
  protocol            = var.protocol
  cloudwatch_alarm_name = module.cloudwatch.alarm_name
  region              = var.region
}
