###########################################################################
# Terraform Config Vars:                                                  #
###########################################################################
variable "provider_region" {
  type        = string
  description = "AWS region to use when making calls to the AWS provider."
  default     = "us-east-1"
}


###########################################################################
# Required KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables require consumer defined values to be provided. #
###########################################################################
variable "cmk_alias" {
  type        = string
  description = "Alias assigned to this CMK."
}

variable "cmk_description" {
  type        = string
  description = "Description of what this CMK will be used for."
}


###########################################################################
# Optional KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
variable "cmk_owners" {
  type        = list(string)
  description = "Owners of the Demo CMK."
  default     = []
}

variable "cmk_admins" {
  type        = list(string)
  description = "Admins of the Demo CMK."
  default     = []
}

variable "cmk_users" {
  type        = list(string)
  description = "Users of the Demo CMK."
  default     = []
}

variable "cmk_grantees" {
  type        = list(string)
  description = "Resource Grantees of the Demo CMK."
  default     = []
}

variable "cmk_tags" {
  type        = map
  description = "Specify any tags that should be added to the KMS CMK being provisioned."
  default     = {
    Provisoned_By  = "Terraform"
    Module_GitHub_URL     = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
  }
}