# Terraform configuration 
terraform {
  required_version = ">= 0.12"
}

#Provider configuration. Typically there will only be one provider config, unless working with multi account and / or multi region resources
provider "aws" {
  region = var.provider_region
}

#################
# KMS CMK Module
#################

// Create the required KMS Key
module "demo_cmk" {
  source = "git@github.com:CloudMage-TF/AWS-KMS-Module.git?ref=v1.0.2"

  // Required Examples
  kms_key_description       = var.cmk_description
  kms_key_alias_name        = var.cmk_alias
  
  // Optional
  # kms_owner_principal_list    = var.cmk_owners
  # kms_admin_principal_list    = var.cmk_admins
  # kms_user_principal_list     = var.cmk_users
  # kms_resource_principal_list = var.cmk_grantees
  # kms_tags                    = var.cmk_tags
}