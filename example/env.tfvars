# KMS CMK Module Variables #
############################
cmk_description = "CMK that will be used to encrypt all of the EBS goodness."
cmk_alias       = "cmk/ebs"
cmk_owners      = []
cmk_admins      = ["arn:aws:iam::123456789101:root"]
cmk_users       = ["arn:aws:iam::123456789101:root"]
cmk_grantees    = ["arn:aws:iam::123456789101:root"]