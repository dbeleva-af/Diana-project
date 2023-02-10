variable "diana-vpc" {
  type    = string
  default = "vpc-0c37d87571b267fe5"
}

variable "aws-region" {
  default = "eu-central-1"
}

variable "project-buildspec" {
  default = "buildspec.yml"
}

variable "subnets" {
  type = list(string)
  default = [
    "public-subnet1",
    "public-subnet2",
    "private-subnet1",
    "private-subnet2"
  ]
}

variable "image_repo_name" {
  default = "flask-application-demo"
}
variable "image_tag" {
  default = "latest"
}

variable "url-repo" {
  default = "https://github.com/dbeleva-af/Diana-project.git"
}

variable "github_oauth_token" {
  description = "token for GitHub"
}

variable "diana-project" {
  description = "the name of the project"
  default     = "diana-project"
}

variable "inline-policy" {
  description = "polici for ecs-task-role"
  default     = "inline-policy"
}

variable "account_id" {
  default = "551047211695"
}

