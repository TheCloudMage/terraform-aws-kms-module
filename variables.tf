######################
# KMS Key Vars:      #
######################
variable "kms_key_description" {
  type        = string
  description = "The description that will be applied to the provisioned KMS Key."
}

variable "kms_owner_principal_list" {
  type        = list
  description = "A list of users/roles/accounts that will own the provisioned KMS Key."
  default     = []
}

variable "kms_admin_principal_list" {
  type        = list
  description = "A list of users/roles that will administrator the provisioned KMS Key."
  default     = []
}

variable "kms_user_principal_list" {
  type        = list
  description = "A list of users/roles that will be granted usage of the provisioned KMS Key."
  default     = []
}

variable "kms_resource_principal_list" {
  type        = list
  description = "A list of users/roles that will be granted permissions to create/list/delete temporary grants to the provisioned KMS Key."
  default     = []
}

######################
# KMS Key Alias Vars:#
######################
variable "kms_key_alias_name" {
  type        = string
  description = "The alias that will be used to reference the provisioned KMS Key. This value will be appended to alias/ in the module."
}
