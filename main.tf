######################
# Data Sources:      #
######################
data "aws_caller_identity" "current" {}

######################
# KMS Key:           #
######################
resource "aws_kms_key" "this" {
  description             = var.kms_key_description
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.this.json

  // Set the Name tag, and add Created_By, Creation_Date, and Creator_ARN tags with ignore change lifecycle policy.
  // Allow Updated_On to update on each exectuion.
  tags = merge(
    var.kms_tags,
    {
      Name            = lower(format("%s", var.kms_key_alias_name)),
      Created_By      = data.aws_caller_identity.current.user_id
      Creator_ARN     = data.aws_caller_identity.current.arn
      Creation_Date   = timestamp()
      Updated_On      = timestamp()
    }
  )

  lifecycle {
    ignore_changes = [tags["Created_By"], tags["Creation_Date"], tags["Creator_ARN"]]
  }
}

######################
# KMS Key Policy:    #
######################
// Construct the Owner policy given to the root user to enable IAM User Permissions
data "aws_iam_policy_document" "kms_owner_policy" {

  statement {
    
    sid           = "KMSKeyOwnerPolicy"
    
    principals {
      type        = "AWS"
      identifiers = length(var.kms_owner_principal_list) > 0 ? var.kms_owner_principal_list : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    
    actions       = ["kms:*"]
    
    resources     = ["*"]
  }
}

// Construct the Administrator policy to define users/roles allowed to assume and administer this Key
data "aws_iam_policy_document" "kms_admin_policy" {

  statement {
    
    sid           = "KMSKeyAdministrationPolicy"
    
    principals {
      type        = "AWS"
      identifiers = length(var.kms_admin_principal_list) > 0 ? var.kms_admin_principal_list : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    
    actions      = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }
}

// Use policy overrides to evalute a new policy to pass to the next layer.
// This is essentially a dynamic conditional merge of the kms_owner and kms_admin policies.
data "aws_iam_policy_document" "temp_kms_owner_kms_admin_merge_policy" {
  source_json   = data.aws_iam_policy_document.kms_owner_policy.json
  override_json = "${length(var.kms_admin_principal_list) > 0 ? data.aws_iam_policy_document.kms_admin_policy.json : null}"
}

// Construct the Users policy to define users/roles allowed to assume this role and use this Key
data "aws_iam_policy_document" "kms_user_policy" {

  statement {
    
    sid       = "KMSKeyUserPolicy"
    
    principals {
      type        = "AWS"
      identifiers = length(var.kms_user_principal_list) > 0 ? var.kms_user_principal_list : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
    ]
    resources = ["*"]
  }
}

// Use policy overrides to evalute a new policy to pass to the next layer.
// This is essentially a dynamic conditional merge of the [kms_owner, kms_admin] and kms_user policies.
data "aws_iam_policy_document" "temp_kms_admin_kms_user_merge_policy" {
  source_json   = data.aws_iam_policy_document.temp_kms_owner_kms_admin_merge_policy.json
  override_json = "${length(var.kms_user_principal_list) > 0 ? data.aws_iam_policy_document.kms_user_policy.json : null}"
}

// Construct the Resource policy to define services that are allowed to List, Create, and Revoke Grants to this Key
data "aws_iam_policy_document" "kms_resource_policy" {  

  statement {  
    
    sid       = "KMSKeyGrantPolicy"
    
    principals {
      type        = "AWS"
      identifiers = length(var.kms_resource_principal_list) > 0 ? var.kms_resource_principal_list : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions      = [
      "kms:ListGrants",
      "kms:CreateGrant",
      "kms:RevokeGrant",
    ]
    resources = ["*"]

    condition {
      test       = "Bool"
      variable   = "kms:GrantIsForAWSResource"

      values     = [
        true
      ]
    }
  }
}

// Use policy overrides to evalute final KMS Key policy.
// This is essentially a dynamic conditional merge of the [kms_owner, kms_admin, kms_user] and kms_resource policies.
data "aws_iam_policy_document" "this" {
  source_json   = data.aws_iam_policy_document.temp_kms_admin_kms_user_merge_policy.json
  override_json = "${length(var.kms_resource_principal_list) > 0 ? data.aws_iam_policy_document.kms_resource_policy.json : null}"
}

######################
# KMS Key Alias:     #
######################
resource "aws_kms_alias" "this" {
  name          = "alias/${var.kms_key_alias_name}"
  target_key_id = aws_kms_key.this.key_id
}