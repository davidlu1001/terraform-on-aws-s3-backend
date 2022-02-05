provider "aws" {
  region = "ap-southeast-2"
}

module "s3backend" {
  source    = "../../"
  namespace = "default"
}
