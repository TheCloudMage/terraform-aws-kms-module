variable "provider_region" {
  type        = string
  description = "AWS region to use when making calls to the AWS provider."
  default     = "us-east-1"
}

variable "cmk_description" {
  type        = string
  description = "Description of what this CMK will be used for."
}

variable "cmk_alias" {
  type        = string
  description = "Alias assigned to this CMK."
}

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