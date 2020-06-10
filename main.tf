######################
# Local Variables:   #
######################
locals {
  grant_condition = {
    test     = "Bool"
    variable = "kms:GrantIsForAWSResource"
    values   = [true]
  }
}

######################
# Data Sources:      #
######################
data "aws_caller_identity" "current" {}

######################
# KMS Key:           #
######################
resource "aws_kms_key" "this" {
  count = var.module_enabled? 1 : 0

  description              = var.description
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  policy                   = var.policy == "AUTO_GENERATE" ? data.aws_iam_policy_document.this.json : var.policy

  // Set the Name tag, and add Created_By, Creation_Date, and Creator_ARN tags with ignore change lifecycle policy.
  // Allow Updated_On to update on each exectuion.
  tags = merge(
    var.tags,
    {
      Name          = lower(format("%s", var.name)),
      Created_By    = data.aws_caller_identity.current.user_id
      Creator_ARN   = data.aws_caller_identity.current.arn
      Creation_Date = timestamp()
      Updated_On    = timestamp()
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
data "aws_iam_policy_document" "owner_policy" {

  statement {

    sid = "KeyOwnerPolicy"

    principals {
      type        = "AWS"
      identifiers = length(var.key_owners) > 0 ? var.key_owners : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }
}

// Construct the Administrator policy to define users/roles allowed to assume and administer this Key
data "aws_iam_policy_document" "admin_policy" {

  statement {

    sid = "KeyAdminPolicy"

    principals {
      type        = "AWS"
      identifiers = length(var.key_admins) > 0 ? var.key_admins : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
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
data "aws_iam_policy_document" "owner_and_admin_policy_merge" {
  source_json   = data.aws_iam_policy_document.owner_policy.json
  override_json = "${length(var.key_admins) > 0 ? data.aws_iam_policy_document.admin_policy.json : null}"
}

// Construct the Users policy to define users/roles allowed to assume this role and use this Key
data "aws_iam_policy_document" "user_policy" {

  statement {

    sid = "KeyUserPolicy"

    principals {
      type        = "AWS"
      identifiers = length(var.key_users) > 0 ? var.key_users : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
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
data "aws_iam_policy_document" "admin_and_user_policy_merge" {
  source_json   = data.aws_iam_policy_document.owner_and_admin_policy_merge.json
  override_json = "${length(var.key_users) > 0 ? data.aws_iam_policy_document.user_policy.json : null}"
}

// Construct the Resource policy to define services that are allowed to List, Create, and Revoke Grants to this Key
data "aws_iam_policy_document" "grantee_policy" {

  statement {

    sid = "KeyGrantPolicy"

    principals {
      type        = "AWS"
      identifiers = length(var.key_grantees) > 0 ? var.key_grantees : ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:ListGrants",
      "kms:CreateGrant",
      "kms:RevokeGrant",
    ]
    resources = ["*"]

    // Dynamically create the condition block only if var.key_grant_resource_restriction is set to true
    dynamic "condition" {
      for_each = var.key_grant_resource_restriction ? [local.grant_condition] : []

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

// Use policy overrides to evalute final KMS Key policy.
// This is essentially a dynamic conditional merge of the [kms_owner, kms_admin, kms_user] and kms_resource policies.
data "aws_iam_policy_document" "this" {
  source_json   = data.aws_iam_policy_document.admin_and_user_policy_merge.json
  override_json = "${length(var.key_grantees) > 0 ? data.aws_iam_policy_document.grantee_policy.json : null}"
}

######################
# KMS Key Alias:     #
######################
resource "aws_kms_alias" "this" {
  count = var.module_enabled? 1 : 0

  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this[0].key_id
}
