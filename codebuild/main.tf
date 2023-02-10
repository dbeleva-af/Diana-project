data "aws_region" "current" {}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Connection CB to VPC"
  vpc_id      = "vpc-0c37d87571b267fe5"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "import_source_credentials" {

  triggers = {
    github_oauth_token = var.github_oauth_token
 }

  provisioner "local-exec" {
    command = <<EOF
      aws --region ${data.aws_region.current.name} codebuild import-source-credentials \
                                                             --token ${var.github_oauth_token} \
                                                             --server-type GITHUB \
                                                             --auth-type PERSONAL_ACCESS_TOKEN
EOF
  }
}

resource "aws_codebuild_project" "diana-project" {
  name         = "${var.diana-project}"
  service_role = "${aws_iam_role.ecs-task-role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }
 source {
    buildspec = var.project-buildspec
    type = "GITHUB"
    location = var.url-repo
    git_clone_depth = 1
    report_build_status = "true"
  }

 environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
}

resource "aws_codebuild_webhook" "build-trigger" {
  project_name = aws_codebuild_project.diana-project.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
           type    = "HEAD_REF"
      pattern = "master"
    }
  }
}
                                                                  
