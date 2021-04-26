terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = var.default_region
}

module "naming" {
  source = "../../../../_module/naming"
  role   = local.role
}

resource "aws_codebuild_project" "build" {
  name         = module.naming.name
  service_role = aws_iam_role.role.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }
  source {
    type      = "GITHUB"
    location  = "https://github.com/EgumaYuto/sample-docker-application"
    buildspec = "buildspec.yml"
  }
}