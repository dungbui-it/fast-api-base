data "aws_ecr_authorization_token" "token" {}
data "aws_caller_identity" "current" {}

provider "aws" {
  # configurations for AWS provider use tfvars file
  region = var.aws_region
}

provider "docker" {
  registry_auth {
    address  = format("%s.dkr.ecr.%s.amazonaws.com", data.aws_caller_identity.current.account_id, var.aws_region)
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}
