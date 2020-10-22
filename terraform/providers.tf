#
# Provider Configuration
#

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

data "aws_caller_identity" "current" {

}