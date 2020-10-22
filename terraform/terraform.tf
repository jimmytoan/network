#
# Terraform Configuration
#

terraform {
  backend "s3" {
    bucket         = "tf-state-ap-southeast-1-421376589955"
    key            = "network.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tf-lock"
  }
}