# Terraform configuration 
terraform {
  required_version = ">= 0.12"
}

#Provider configuration. Typically there will only be one provider config, unless working with multi account and / or multi region resources
provider "aws" {
  region = var.provider_region
}

#############################
# KMS CMK Custom Key Policy #
#############################
data "aws_iam_policy_document" "custom_policy" {

  statement {

    sid = "CustomKeyPolicy"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789101:root"]
    }

    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
      "kms:ListGrants",
      "kms:CreateGrant",
      "kms:RevokeGrant",
    ]
    resources = ["*"]
  }
}

#################
# KMS CMK Module
#################
# Test Defaults
module "default_config" {
  source = "../"
  # source = "git@github.com:CloudMage-TF/AWS-KMS-Module.git?ref=v1.0.5"

  name        = var.name
  description = var.description

  tags = var.tags
}

# Test Custom Policy
module "custom_policy" {
  source = "../"
  # source = "git@github.com:CloudMage-TF/AWS-KMS-Module.git?ref=v1.0.5"

  name                     = var.name
  description              = var.description
  enable_key_rotation      = var.enable_key_rotation
  deletion_window_in_days  = var.deletion_window_in_days
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  policy                   = data.aws_iam_policy_document.custom_policy.json
}

# Test Key Policy Generation
module "key_policy_condition" {
  source = "../"
  # source = "git@github.com:CloudMage-TF/AWS-KMS-Module.git?ref=v1.0.5"

  name         = var.name
  description  = var.description
  key_owners   = var.key_owners
  key_admins   = var.key_admins
  key_grantees = var.key_grantees
}

# Test Key Policy Generation
module "key_policy_no_condition" {
  source = "../"
  # source = "git@github.com:CloudMage-TF/AWS-KMS-Module.git?ref=v1.0.5"

  name         = var.name
  description  = var.description
  key_users    = ["arn:aws:iam::123456789101:user/TPol"]
  key_grantees = var.key_grantees

  key_grant_resource_restriction = var.key_grant_resource_restriction
}