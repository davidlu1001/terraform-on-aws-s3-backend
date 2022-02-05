variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  default     = "default"
  type        = string
}

variable "principal_arns" {
  description = "A list of principal arns allowed to assume the IAM role"
  default     = null
  type        = list(string)
}

variable "force_destroy_state" {
  description = "Force destroy the s3 bucket containing state files?"
  default     = true
  type        = bool
}

variable "kms_enable_key_rotation" {
  type        = string
  default     = true
  description = "Specifies whether KMS key rotation is enabled."
}

variable "kms_deletion_window_in_days" {
  type        = number
  default     = 10
  description = "Duration in days after which the KMS key is deleted after destruction of the resource."
}
