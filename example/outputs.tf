######################
# KMS Key:           #
######################
output "cmk_arn" {
  value = module.demo_cmk.kms_key_arn
}
output "cmk_id" {
  value = module.demo_cmk.kms_key_id
}

######################
# KMS Key Alias:     #
######################
output "cmk_alias" {
  value = module.demo_cmk.kms_key_alias
}
