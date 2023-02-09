terraform {
  backend "s3" {
    bucket         = "dianabucket1-demo"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "dianadb1-demo"
  }
}
