data "aws_region" "current" {}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "group-${var.namespace}"

  resource_query {
    query = <<-JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "ResourceGroup",
      "Values": ["${var.namespace}"]
    }
  ]
}
  JSON
  }
}

data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket        = "state-bucket-${var.namespace}"
  force_destroy = var.force_destroy_state

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = data.aws_kms_alias.s3.arn
      }
    }
  }

  tags = {
    ResourceGroup = var.namespace
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "state-lock-${var.namespace}"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    ResourceGroup = var.namespace
  }
}
