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
module "demo_cmk" {
  source = "../"
  # source = "git@github.com:CloudMage-TF/AWS-KMS-Module.git?ref=v1.0.5"

  // Required Variable Example
  name        = var.name
  description = var.description

  // Optional Variable Example
  # policy        = data.aws_iam_policy_document.custom_policy.json
  # key_owners    = var.key_owners
  # key_admins    = var.key_admins
  # key_users     = var.key_users
  # key_grantees  = var.key_grantees
  # key_grant_resource_restriction = var.key_grant_resource_restriction
  # key_grant_resource_restriction = false
  # tags           = var.tags
}