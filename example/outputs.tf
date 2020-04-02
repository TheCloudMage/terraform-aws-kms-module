######################
# KMS Key Outputs:   #
######################
output "key_id" {
  description = "The globally unique identifier for the key."
  value       = module.demo_cmk.key_id
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = module.demo_cmk.key_arn
}

##########################
# KMS Key Alias Outputs: #
##########################
output "alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = module.demo_cmk.alias_arn
}

output "target_key_arn" {
  description = "The Amazon Resource Name (ARN) of the target key identifier."
  value       = module.demo_cmk.target_key_arn
}
