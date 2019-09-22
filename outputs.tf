######################
# KMS Key:           #
######################
output "kms_key_arn" {
  value = aws_kms_key.this.arn
}

output "kms_key_id" {
  value = aws_kms_key.this.id
}

######################
# KMS Key Alias:     #
######################
output "kms_key_alias" {
  value = aws_kms_alias.this.arn
}
