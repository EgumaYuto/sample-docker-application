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
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = local.aws_default_region
    }

    environment_variable {
      name  = "REPOSITORY_URI"
      value = local.repository_uri
    }
  }
  source {
    type      = "GITHUB"
    location  = "https://github.com/EgumaYuto/sample-docker-application"
    buildspec = "buildspec.yml"
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/codebuild/${aws_codebuild_project.build.name}"
  retention_in_days = 7
}