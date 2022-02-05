output "s3_bucket" {
  description = "S3 bucket for state"
  value       = aws_s3_bucket.s3_bucket.bucket
}

output "dynamodb_table" {
  description = "Dynamodb table for locking"
  value       = aws_dynamodb_table.dynamodb_table.name
}

output "state_role_arn" {
  description = "State role arn"
  value       = aws_iam_role.iam_role.arn
}
