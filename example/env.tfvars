###########################################################################
# Terraform Config Vars:                                                  #
###########################################################################
provider_region = "us-east-1"

###########################################################################
# Required KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables require consumer defined values to be provided. #
###########################################################################
name        = "cmk/ebs"
description = "CMK that will be used to encrypt all of the EBS goodness."


###########################################################################
# Optional KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
enable_key_rotation            = false
deletion_window_in_days        = 14
key_usage                      = "SIGN_VERIFY"
customer_master_key_spec       = "RSA_2048"
key_owners                     = ["arn:aws:iam::123456789101:root", "arn:aws:iam::109876543210:root"]
key_admins                     = ["arn:aws:iam::123456789101:role/KMS-KeyPolicy-Admins", "arn:aws:iam::123456789101:user/TPol"]
key_users                      = ["arn:aws:iam::123456789101:role/KMS-KeyPolicy-Users", "arn:aws:iam::123456789101:user/Jean-Luc-Picard"]
key_grantees                   = ["arn:aws:iam::123456789101:user/Data", "arn:aws:iam::123456789101:user/Spock"]
key_grant_resource_restriction = false
policy                         = "AUTO_GENERATE"

tags = {
  Provisioned_By    = "Terraform"
  Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
}
