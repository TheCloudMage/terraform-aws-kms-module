###########################################################################
# Required KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables require consumer defined values to be provided. #
###########################################################################
variable "name" {
  type        = string
  description = "The name/alias that will be assigned to the CMK (key). This value will be appended to 'alias/' automatically within the module when creating the key alias resource."
}

variable "description" {
  type        = string
  description = "The description of the CMK (key) as viewed in the AWS KMS console."
}


###########################################################################
# Optional KMS CMK Module Vars:                                           #
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
variable "is_enabled" {
  type        = bool
  description = "Specifies whether the CMK (key) is enabled. Defaults to true."
  default     = true
}

variable "enable_key_rotation" {
  type        = bool
  description = "Specifies whether key rotation is enabled. When rotation occurs, any new objects will be encrypted using the new CMK, however all previous versions of the key will remain available for decryption of any objects previously encrypted by them. No user action is required before, during or after a rotation event. KMS automatically writes the key version to the metadata of any object that is encrypted, and can automatically use a previous version of the key during a decryption request. Defaults to true."
  default     = true
}

variable "deletion_window_in_days" {
  type        = number
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
  default     = 30
}

variable "key_usage" {
  type        = string
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT."
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  type        = string
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT."
  default     = "SYMMETRIC_DEFAULT"
}

variable "key_owners" {
  type        = list
  description = "List of users/roles/accounts that will own and have kms:* on the provisioned KMS CMK."
  default     = []
}

variable "key_admins" {
  type        = list
  description = "List of users/roles/accounts that will be key administrators of the provisioned KMS CMK. Admins have administrative rights, but are not automatically granted usage or grant rights on the key. To enable usage or grant, add the user/role/account to the key_users / key_grantees variables."
  default     = []
}

variable "key_users" {
  type        = list
  description = "List of users/roles/accounts that will be granted usage of the provisioned KMS CMK. Users are only given DescribeKey, GenerateDataKey*, Encrypt, ReEncrypt, and Decrypt permissions on the provisioned KMS CMK."
  default     = []
}

variable "key_grantees" {
  type        = list
  description = "List of users/roles/accounts that will be granted permission to CreateGrant, ListGrants, and RevokeGrant on the provisioned KMS CMK."
  default     = []
}

variable "key_grant_resource_restriction" {
  type        = bool
  description = "Specifies if the grant policy that will be created using the key_grantee list will be conditionally restricted to AWS resources. If grants are required for service-linked roles, this value needs to be set to false. Defaults to true."
  default     = true
}

variable "policy" {
  type        = string
  description = "A valid custom policy JSON document resource. If a custom key policy is desired, an aws_iam_policy_document resource can be created and passed to the module. If the default 'AUTO_GENERATE' value is passed, then the module will use the key_owners, key_admins, key_users, and key_grantees variables to automatically generate a key policy that will be attached to the provisioned KMS CMK."
  default     = "AUTO_GENERATE"
}

variable "tags" {
  type        = map
  description = "Tags that will be applied to the provisioned KMS CMK."
  default = {
    Provisioned_By    = "Terraform"
    Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
  }
}

variable "module_enabled" {
  type        = bool
  description = "Module variable that can be used to disable the module from deploying any resources if called from a multi-account/environment root project. Defaults to true, value of false will effectively turn the module off."
  default     = true
}
