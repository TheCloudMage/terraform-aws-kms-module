###########################################################################
# Terraform Config Vars:                                                  #
###########################################################################


###########################################################################
# Required KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables require consumer defined values to be provided. #
###########################################################################
cmk_description = "CMK that will be used to encrypt all of the EBS goodness."
cmk_alias       = "cmk/ebs"


###########################################################################
# Optional KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
cmk_owners      = []
cmk_admins      = ["arn:aws:iam::123456789101:root"]
cmk_users       = ["arn:aws:iam::123456789101:root"]
cmk_grantees    = ["arn:aws:iam::123456789101:root"]