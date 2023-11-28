locals {
  region = var.aws_region

  # Override per repo basis
  common_tags = {
    Environment = var.environment
    Component   = "data-platform"
    Repository  = "multi-lambda-template"
    Owner       = "felicia@pendulumfn.com"
    Workspace   = terraform.workspace
    Component   = "data-platform"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = local.region

  # Override per repo basis
  default_tags {
    tags = {
      Environment = var.environment
      Component   = "data-platform"
      Repository  = "multi-lambda-template"
      Owner       = "felicia@pendulumfn.com"
      Workspace   = terraform.workspace
      Name        = "data-platform"
    }
  }
}

data "aws_iam_policy_document" "lambda1_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda2_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda1_role" {
  name               = "${terraform.workspace}_lambda1_execution_role"
  assume_role_policy = data.aws_iam_policy_document.lambda1_role_policy.json
}

resource "aws_iam_role" "lambda2_role" {
  name               = "${terraform.workspace}_lambda2_execution_role"
  assume_role_policy = data.aws_iam_policy_document.lambda2_role_policy.json
}


data "aws_iam_policy_document" "lambda_logging" {

  statement {
    sid = "LambdaLogging"
    actions = [
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_execution" {
  source_policy_documents = [data.aws_iam_policy_document.lambda_logging.json]
}

resource "aws_iam_policy" "lambda_execution" {

  name        = "${terraform.workspace}_multi_lambda_template_execution_policy"
  path        = "/"
  description = "IAM policy for the ${terraform.workspace} multi-lambda-template"

  policy = data.aws_iam_policy_document.lambda_execution.json
}


# Attach the policy for logs and other additional permissions to the lambda
resource "aws_iam_role_policy_attachment" "lambda1_permissions" {

  role       = aws_iam_role.lambda1_role.name
  policy_arn = aws_iam_policy.lambda_execution.arn
}

resource "aws_iam_role_policy_attachment" "lambda2_permissions" {

  role       = aws_iam_role.lambda2_role.name
  policy_arn = aws_iam_policy.lambda_execution.arn
}

# Lambda resources
resource "aws_lambda_function" "lambda1" {
  filename      = "../.packages/lambda1.zip"
  function_name = "${terraform.workspace}_lambda1"
  role          = aws_iam_role.lambda1_role.arn
  handler       = "lambda1.app.lambda_handler"

  source_code_hash = filebase64sha256("../.packages/lambda1.zip")

  architectures = ["arm64"]
  runtime       = "python3.10"

  environment {
    variables = {
      LOG_LEVEL = "WARNING"
    }
  }
}

resource "aws_lambda_function" "lambda2" {
  filename      = "../.packages/lambda2.zip"
  function_name = "${terraform.workspace}_lambda2"
  role          = aws_iam_role.lambda1_role.arn
  handler       = "lambda2.app.lambda_handler"

  source_code_hash = filebase64sha256("../.packages/lambda2.zip")

  architectures = ["arm64"]
  runtime       = "python3.8"

  environment {
    variables = {
      LOG_LEVEL = var.logging_level
    }
  }
}
