output "s3_bucket" {
  description = "S3 bucket for state"
  value       = module.s3backend.s3_bucket
}

output "dynamodb_table" {
  description = "Dynamodb table for locking"
  value       = module.s3backend.dynamodb_table
}
