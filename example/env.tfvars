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
key_owners                     = []
key_admins                     = ["arn:aws:iam::123456789101:root"]
key_users                      = ["arn:aws:iam::123456789101:root"]
key_grantees                   = ["arn:aws:iam::123456789101:root"]
key_grant_resource_restriction = true
policy                         = "AUTO_GENERATE"

tags = {
  Provisioned_By    = "Terraform"
  Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
}
