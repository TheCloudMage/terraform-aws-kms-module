###########################################################################
# Terraform Config Vars:                                                  #
###########################################################################


###########################################################################
# Required KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables require consumer defined values to be provided. #
###########################################################################
cmk_alias       = "cmk/ebs"
cmk_description = "CMK that will be used to encrypt all of the EBS goodness."


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
cmk_tags        = {
    Provisoned_By  = "Terraform"
    Module_GitHub_URL     = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
}
