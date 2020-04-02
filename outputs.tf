######################
# KMS Key Outputs:   #
######################
output "key_id" {
  description = "The globally unique identifier for the key."
  value       = aws_kms_key.this.key_id
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = aws_kms_key.this.arn
}

##########################
# KMS Key Alias Outputs: #
##########################
output "alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = aws_kms_alias.this.arn
}

output "target_key_arn" {
  description = "The Amazon Resource Name (ARN) of the target key identifier."
  value       = aws_kms_alias.this.target_key_arn
}
