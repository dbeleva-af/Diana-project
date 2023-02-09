terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.1"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "demo-cluster" {
  name = "demo-cluster"
  tags = {
    Name = "demo-cluster"
  }
}

resource "aws_ecs_task_definition" "demo-task-def" {
  family = "demo-task-def"

  container_definitions = <<DEFINITION
  [
    {
      "name": "demo-task-def",
      "image": "${var.account}.dkr.ecr.eu-central-1.amazonaws.com/diana-project:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "cpu": 256,
      "memory": 512,
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_task_policy.json
}

data "aws_iam_policy_document" "assume_task_policy" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#Creating ECS Service

resource "aws_ecs_service" "demo-first-service" {
  name                 = "demo-first-service"
  cluster              = aws_ecs_cluster.demo-cluster.id
  task_definition      = aws_ecs_task_definition.demo-task-def.arn
  launch_type          = "FARGATE"
  desired_count        = 3
  force_new_deployment = true

  network_configuration {
    subnets          = ["${aws_subnet.public-subnet1.id}", "${aws_subnet.public-subnet2.id}", "${aws_subnet.private-subnet1.id}", "${aws_subnet.private-subnet2.id}"]
    assign_public_ip = true
  }
}

resource "aws_ecr_repository" "diana-repo" {
  name                 = var.aws_ecr_repository
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "diana-repo-policy" {
  repository = aws_ecr_repository.diana-repo.name
  depends_on = [
    aws_ecr_repository.diana-repo
  ]
policy = <<EOF
{
 "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "ecr policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

