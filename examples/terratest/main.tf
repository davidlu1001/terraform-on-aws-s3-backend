terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.69"
    }
  }

  backend "local" {}
}

provider "aws" {
  region = var.region
}

module "s3backend" {
  source              = "../../"
  namespace           = var.namespace
  force_destroy_state = var.force_destroy_state
}
