###########################################################################
# Required KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables require consumer defined values to be provided. #
###########################################################################
variable "kms_key_alias_name" {
  type        = string
  description = "The alias that will be assigned to the provisioned KMS CMK. This value will be appended to alias/ within the module automatically."
}

variable "kms_key_description" {
  type        = string
  description = "The description that will be applied to the provisioned KMS Key."
}


###########################################################################
# Optional KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
variable "kms_owner_principal_list" {
  type        = list
  description = "List of users/roles/accounts that will own and have kms:* on the provisioned CMK."
  default     = []
}

variable "kms_admin_principal_list" {
  type        = list
  description = "List of users/roles that will be key administrators of the provisioned KMS CMK"
  default     = []
}

variable "kms_user_principal_list" {
  type        = list
  description = "List of users/roles that will be granted usage of the provisioned KMS CMK."
  default     = []
}

variable "kms_resource_principal_list" {
  type        = list
  description = "List of users/roles that will be granted permissions to create/list/delete temporary grants to the provisioned KMS CMK."
  default     = []
}

variable "kms_tags" {
  type        = map
  description = "Specify any tags that should be added to the KMS CMK being provisioned."
  default     = {
    Provisoned_By  = "Terraform"
    GitHub_URL     = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
  }
}
