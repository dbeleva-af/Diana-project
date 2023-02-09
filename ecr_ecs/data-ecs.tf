data "aws_iam_policy_document" "ecs-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "ecs-task.amazonaws.com"]
    }
  }
}

data "aws_caller_identity" "current" {}
