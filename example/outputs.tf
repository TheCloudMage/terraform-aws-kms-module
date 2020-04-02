######################
# KMS Key Outputs:   #
######################
output "key_id" {
  description = "The globally unique identifier for the key."
  value       = module.cmk_defaults.key_id
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = module.cmk_defaults.key_arn
}

##########################
# KMS Key Alias Outputs: #
##########################
output "alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = module.cmk_defaults.alias_arn
}

output "target_key_arn" {
  description = "The Amazon Resource Name (ARN) of the target key identifier."
  value       = module.cmk_defaults.target_key_arn
}
