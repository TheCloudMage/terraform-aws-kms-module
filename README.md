<!-- VSCode Markdown Exclusions-->
<!-- markdownlint-disable MD025 Single Title Headers-->

# CloudMage KMS Terraform Module Documentation

![CloudMage](images/tf_kms.png)

<br>

![Version-Badge](https://img.shields.io/badge/MODULE%20VERSION-v1.0.5-Green?style=for-the-badge&logo=terraform&logoColor=BLUE&logoWidth=25)

<br><br>

# Table of Contents

* [Getting Started](#getting-started)
* [Module Pre-Requisites and Dependencies](#module-pre-requisites-and-dependencies)
* [Module Directory Structure](#module-directory-structure)
* [Module Usage](#module-usage)
* [Terraform Variable Usage](#terraform-variables-usage)
  * [Inline Variable Declaration](#inline-variable-declaration)
  * [TFVar Variable Declaration](#tfvar-variable-declaration)
* [Required Module Variables](#required-variables)
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/required-codeblock-drop.png) &nbsp; [*name*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/required-codeblock-drop.png) &nbsp; [*description*]('')
* [Optional Module Variables](#optional-module-variables)
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*is_enabled*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*enable_key_rotation*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*deletion_window_in_days*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*key_usage*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*customer_master_key_spec*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*key_owners*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*key_admins*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*key_users*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*key_grantees*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*key_grant_resource_restriction*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*policy*]('')
  * ![required_variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/optional-codeblock-drop.png) &nbsp; [*tags*]('')
* [Module Example Usage](#module-example-usage)
* [Variables and TFVar Reference File Templates](#variables-and-tfvar-reference-file-templates)
* [Module Outputs Reference File Templates](#module-outputs-reference-file-templates)
* [Terraform Requirements](#terraform-requirements)
* [Recommended Terraform Utilities](#recommended-terraform-utilities)
* [Contacts and Contributions](#contacts-and-contributions)

<br><br>

# Getting Started

This Terraform module was created to quickly and easily provision a secure AWS Key Management Service (KMS) Customer Managed Key (CMK). CMK's are used for server-side encryption on AWS services such as S3 buckets, EBS volumes, Dynamo DB Tables, or any other service where data encryption is required. This module also includes optional variables that allow the consumer of the module to choose how KMS Key policies will be automatically constructed and placed on be the CMK at the time of provisioning.

<br>

If none of the optional variables for automatic key policy generation are defined, a key policy with the following permissions will be created automatically and applied to the requested KMS CMK during module execution. Note that the module uses the `data "aws_caller_identity" "current" {}` data source to obtain the account id of the account that the root project was executed against and will use that value to automatically generate the root user ARN specified in the CMK Owner Policy.

<br>

```yaml
Statement:
  - Sid: "KeyOwnerPolicy"
    Effect: Allow
    Principal:
    AWS:
        - "arn:aws:iam::123456789101:root"
    Action:
        - "kms:*"
    Resources: "*"
```

<br><br>

# Module Pre-Requisites and Dependencies

This module does not currently have any pre-requisites or dependency requirements.

<br><br>

# Module Directory Structure

```bash
.
├── outputs.tf
├── main.tf
├── CHANGELOG.md
├── example
│   ├── env.tfvars
│   ├── outputs.tf
│   ├── main.tf
│   ├── README.md
│   └── variables.tf
├── variables.tf
└── magicdoc.yaml

```

<br><br>

# Module Usage

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    # is_enabled                     = True
    # enable_key_rotation            = True
    # deletion_window_in_days        = 30
    # key_usage                      = "ENCRYPT_DECRYPT"
    # customer_master_key_spec       = "SYMMETRIC_DEFAULT"
    # key_owners                     = []
    # key_admins                     = []
    # key_users                      = []
    # key_grantees                   = []
    # key_grant_resource_restriction = True
    # policy                         = "AUTO_GENERATE"

    # tags = {
    #   Provisioned_By = "Terraform"
    #   Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
    # }
}
```

<br><br>

# Terraform Variable Usage

Module variables that need to either be defined or re-defined with a non-default value can easily be hardcoded inline directly within the module call block or from within the root project that is consuming the module. If using the second approach then the root project must have it's own custom variables defined within the projects `variables.tf` file with set default values or with the values provided from a separate environmental `terraform.tfvar` file. Examples of both approaches can be found below. Note that for the standards used within this documentation, all variables will mostly use the first approach for ease of readability.

<br><br>

> ![Tip](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/24/info.png) &nbsp;[__Tip:__](Tip) <br> There is also a third way to provide variable values using Terraform data sources. A data source is a unique type of code block used within a project that either instantiates or collects data that can be referenced throughout the project. A data source, for example,  can be declared to read the terraform state file and gather all of the available information from a previously deployed project stack. Any of the data contained within the data source can then be referenced to set the value of a project or module variable.

<br><br>

## Inline Variable Declaration

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."
}
```

<br><br>

## TFVar Variable Declaration

<br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; [variables.tf](variables.tf)

```terraform
variable "name" {
    type        = string
    description = "The name/alias that will be assigned to the CMK (key). This value will be appended to 'alias/' automatically within the module when creating the key alias resource."
}
variable "description" {
    type        = string
    description = "The description of the CMK (key) as viewed in the AWS KMS console."
}
```

<br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; [terraform.tfvars](terraform.tfvars)

```terraform
name        = "cmk/ebs"
description = "Primary EBS Volume Encryption Key for the Production environment."
```

<br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; [main.tf](main.tf)

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = tf.name
    description = tf.description
}
```

<br><br>

# Required Variables

The following required module variables do not contain default values and must be set by the consumer of the module to use the module successfully.

<br>

## ![Required_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/required-shieldblock.png) &nbsp; [name](tfvar.name)

<br>

The name/alias that will be assigned to the CMK (key). This value will be appended to 'alias/' automatically within the module when creating the key alias resource.

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> The required `alias/` prefix is already defined in the module and not required as part of the variable string.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [name](name) within the modules variables.tf file

```terraform
variable "name" {
    type        = string
    description = "The name/alias that will be assigned to the CMK (key). This value will be appended to 'alias/' automatically within the module when creating the key alias resource."
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [name](name) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Declaring the "name" variable
    name        = "cmk/ebs"

    // Other Required Variables
    description = "Primary EBS Volume Encryption Key for the Production environment."
}
```

<br><br><br>

## ![Required_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/required-shieldblock.png) &nbsp; [description](tfvar.name)

<br>

The description of the CMK (key) as viewed in the AWS KMS console.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [description](description) within the modules variables.tf file

```terraform
variable "description" {
    type        = string
    description = "The description of the CMK (key) as viewed in the AWS KMS console."
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [description](description) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Declaring the "description" variable
    description = "Primary EBS Volume Encryption Key for the Production environment."

    // Other Required Variables
    name        = "cmk/ebs"
}
```

<br><br><br>

# Optional Module Variables

The following optional module variables are not required because they already have default values assigned when the variables where defined within the modules `variables.tf` file. If the default values do not need to be changed by the root project consuming the module, then they do not even need to be included in the root project. If any of the variables do need to be changed, then they can be added to the root project in the same way that the required variables were defined and utilized. Optional variables also may alter how the module provisions resources in the cases of encryption or IAM policy generation. A variable could flag an encryption requirement when provisioning an S3 bucket or Dynamo table by providing a KMS CMK, for example. Another use case may be the passage of ARN values to allow users or roles access to services or resources, whereas by default permissions would be more restrictive or only assigned to the account root or a single IAM role. A detailed explanation of each of these optional variables can be found below:

<br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [is_enabled](tfvar.name)

<br>

Specifies whether the CMK (key) is enabled. Defaults to true.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [is_enabled](is_enabled) within the modules variables.tf file

```terraform
variable "is_enabled" {
    type        = bool
    description = "Specifies whether the CMK (key) is enabled. Defaults to true."
    default     = true
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [is_enabled](is_enabled) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    is_enabled = true
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [enable_key_rotation](tfvar.name)

<br>

Specifies whether key rotation is enabled. When rotation occurs, any new objects will be encrypted using the new CMK, however all previous versions of the key will remain available for decryption of any objects previously encrypted by them. No user action is required before, during or after a rotation event. KMS automatically writes the key version to the metadata of any object that is encrypted, and can automatically use a previous version of the key during a decryption request. Defaults to true.

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> From a general security perspective it is highly recommend to enable key rotation on KMS encryption keys.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [enable_key_rotation](enable_key_rotation) within the modules variables.tf file

```terraform
variable "enable_key_rotation" {
    type        = bool
    description = "Specifies whether key rotation is enabled. When rotation occurs, any new objects will be encrypted using the new CMK, however all previous versions of the key will remain available for decryption of any objects previously encrypted by them. No user action is required before, during or after a rotation event. KMS automatically writes the key version to the metadata of any object that is encrypted, and can automatically use a previous version of the key during a decryption request. Defaults to true."
    default = true
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [enable_key_rotation](enable_key_rotation) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    enable_key_rotation = true
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [deletion_window_in_days](tfvar.name)

<br>

Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [deletion_window_in_days](deletion_window_in_days) within the modules variables.tf file

```terraform
variable "deletion_window_in_days" {
    type        = number
    description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 30 days."
    default     = 30
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [deletion_window_in_days](deletion_window_in_days) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    deletion_window_in_days = 14
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [key_usage](tfvar.name)

<br>

Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [key_usage](key_usage) within the modules variables.tf file

```terraform
variable "key_usage" {
    type        = string
    description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. Defaults to ENCRYPT_DECRYPT."
    default     = "ENCRYPT_DECRYPT"
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [key_usage](key_usage) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    key_usage = "ENCRYPT_DECRYPT"
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [customer_master_key_spec](tfvar.name)

<br>

Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT.

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> SYMMETRIC_DEFAULT must be selected if the key being provisioned will be used to encrypt object stored in S3.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [customer_master_key_spec](customer_master_key_spec) within the modules variables.tf file

```terraform
variable "customer_master_key_spec" {
    type        = string
    description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption or signing algorithms that the key supports. Valid values: SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, or ECC_SECG_P256K1. Defaults to SYMMETRIC_DEFAULT."
    default     = "SYMMETRIC_DEFAULT"
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [customer_master_key_spec](customer_master_key_spec) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [key_owners](tfvar.name)

<br>

List of users/roles/accounts that will own and have kms:* on the provisioned KMS CMK.

<br>

This variable is used to define a list of users/roles that will be added to the KMS Key Owner policy statement. If the variable is not defined, then the key owner policy will be included to contain the account root user, allowing IAM the ability to assign key permissions using standard IAM policies. If a list of roles/users is defined, then the provided list will instead be used to determine the key owner principals. Typically this variable will only be used if the CMK will be shared, and the key provisioner needs to make another AWS account a key owner to allow IAM policies in the other account to define permission for the provisioned shared key.

Without defining this variable a key policy with the following permissions will be created and applied to the requested KMS key:

```yaml
Statement:
- Sid: "KeyOwnerPolicy"
    Effect: Allow
    Principal:
    AWS:
        - "arn:aws:iam::123456789101:root"
    Action:
        - "kms:*"
    Resources: "*"
```

<br>

If a list defining any IAM users/roles/accounts is defined into the variable, a key policy with the following permissions will be created and applied to the requested KMS CMK instead of the default policy referenced above:

<br>

```yaml
Statement:
- Sid: "KeyOwnerPolicy"
    Effect: Allow
    Principal:
    AWS:
        - "arn:aws:iam::123456789101:root"
        - "arn:aws:iam::109876543210:root"
    Action:
        - "kms:*"
    Resources: "*"
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> The key owner policy statement determines what users/roles own the provisioned KMS key. Owners have `kms:*` permissions on the CMK. They can perform any action on the key including performing any modifications to the key and the key policy.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [key_owners](key_owners) within the modules variables.tf file

```terraform
variable "key_owners" {
    type        = list
    description = "List of users/roles/accounts that will own and have kms:* on the provisioned KMS CMK."
    default     = []
}
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> You can not assign an IAM group as a policy principal, only IAM users/roles are allowed as policy principals.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [key_owners](key_owners) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    key_owners = ["arn:aws:iam::123456789101:root"]
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [key_admins](tfvar.name)

<br>

List of users/roles/accounts that will be key administrators of the provisioned KMS CMK. Admins have administrative rights, but are not automatically granted usage or grant rights on the key. To enable usage or grant, add the user/role/account to the key_users / key_grantees variables.

<br>

If a list of roles/users (including a list of a single user or role) is provided, then a KMS key Administrator policy will be generated automatically and appended to the key policy that will be applied to the provisioned CMK. If this variable is left empty or not included in the module call, then the KMS key administrator policy statement **will not be included** in the KMS key policy. The account root owner will still have kms:* permissions, but no additional administrators will be added. IAM policies can be constructed post key creation in order to grant permissions, including administration permissions to users/roles later by the key owner.

<br>

If a list defining any IAM users/roles is defined into the variable, a key policy with the following permissions will be created and applied to the requested KMS CMK:

```yaml
Statement:
- Sid: "KeyAdminPolicy"
    Effect: Allow
    Principal:
    AWS:
        - "arn:aws:iam::123456789101:role/AWS-KMS-Admin-Role"
        - "arn:aws:iam::123456789101:user/kms_admin"
    Action:
        - "kms:Create*"
        - "kms:Describe*"
        - "kms:Enable*"
        - "kms:List*"
        - "kms:Put*"
        - "kms:Update*"
        - "kms:Revoke*"
        - "kms:Disable*"
        - "kms:Get*"
        - "kms:Delete*"
        - "kms:TagResource"
        - "kms:UntagResource"
        - "kms:ScheduleKeyDeletion"
        - "kms:CancelKeyDeletion"
    Resources: "*"
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> The key administrator policy statement determines what users/roles have administrative rights on the provisioned KMS key. Key administrators can modify the key and the key policy, but they are not granted usage of the key, or the ability to manage grants for the key. If a key administrator requires usage permissions, then they would also need to be added to the key usage policy statement.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [key_admins](key_admins) within the modules variables.tf file

```terraform
variable "key_admins" {
    type        = list
    description = "List of users/roles/accounts that will be key administrators of the provisioned KMS CMK. Admins have administrative rights, but are not automatically granted usage or grant rights on the key. To enable usage or grant, add the user/role/account to the key_users / key_grantees variables."
    default     = []
}
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> You can not assign an IAM group as a policy principal, only IAM users/roles are allowed as policy principals.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [key_admins](key_admins) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    key_admins = ["arn:aws:iam::123456789101:role/AWS-KMS-Admin-Role"]
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [key_users](tfvar.name)

<br>

List of users/roles/accounts that will be granted usage of the provisioned KMS CMK. Users are only given DescribeKey, GenerateDataKey*, Encrypt, ReEncrypt, and Decrypt permissions on the provisioned KMS CMK.

<br>

This variable is used to define a list of users/roles that will be added to the KMS Key usage policy statement block. If a list of roles/users (including a list of a single user or role) is provided, then a KMS key usage policy will be generated automatically and appended to the key policy that will be applied to the provisioned CMK. If this variable is left empty or not included in the module call, then the KMS key usage policy statement **will not be included** in the KMS key policy. The account root owner will still have kms:* permissions, but no additional key users will be added. IAM policies can be constructed post key creation in order to grant permissions, including key usage permissions to users/roles later by the key owner or a key administrator.

<br>

If a list defining any IAM users/roles is defined into the variable, a key policy with the following permissions will be created and applied to the requested KMS CMK:

<br>

```yaml
Statement:
- Sid: "KeyUserPolicy"
    Effect: Allow
    Principal:
    AWS:
        - "arn:aws:iam::123456789101:role/AWS-RDS-Service-Role"
        - "arn:aws:iam::123456789101:user/rnason"
    Action:
        - "kms:DescribeKey"
        - "kms:GenerateDataKey*"
        - "kms:Encrypt"
        - "kms:ReEncrypt*"
        - "kms:Decrypt"
    Resources: "*"
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> The key usage policy statement determines what users/roles have rights to encrypt, decrypt, re-encrypt, and generate data key operations with the provisioned CMK. Any users/roles that are included in this policy statement have no other rights on the key unless they are also added to one of the other key policy statement blocks also.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [key_users](key_users) within the modules variables.tf file

```terraform
variable "key_users" {
    type        = list
    description = "List of users/roles/accounts that will be granted usage of the provisioned KMS CMK. Users are only given DescribeKey, GenerateDataKey*, Encrypt, ReEncrypt, and Decrypt permissions on the provisioned KMS CMK."
    default     = []
}
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> You can not assign an IAM group as a policy principal, only IAM users/roles are allowed as policy principals.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [key_users](key_users) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    key_users = ["arn:aws:iam::123456789101:role/AWS-RDS-Service-Role", "arn:aws:iam::123456789101:user/rnason"]
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [key_grantees](tfvar.name)

<br>

List of users/roles/accounts that will be granted permission to CreateGrant, ListGrants, and RevokeGrant on the provisioned KMS CMK.

<br>

This variable is used to define a list of users/roles/accounts that will be added to the KMS Key resource grant policy statement block. If a list of roles/users (including a list of a single user or role) is provided, then a KMS key resource grant policy will be generated automatically and appended to the key policy that will be applied to the provisioned CMK. If this variable is left empty or not included in the module call, then the KMS key resource grant policy statement **will not be included** in the KMS key policy. The account root owner will still have kms:* permissions, but no additional key resource grant permissions will be added. IAM policies can be constructed post key creation in order to grant permissions, including key grantee permissions to users/roles later by the key owner or a key administrator.

<br>

If a list defining any IAM users/roles is defined in the variable, a key policy with the following permissions will be created and applied to the requested KMS CMK:

<br>

```yaml
Statement:
- Sid: "KeyGrantPolicy"
    Effect: Allow
    Principal:
    AWS:
        - "arn:aws:iam::123456789101:role/AWS-RDS-Service-Role"
        - "arn:aws:iam::123456789101:user/rnason"
    Action:
        - "kms:ListGrants"
        - "kms:CreateGrant"
        - "kms:RevokeGrant"
    Resources: "*"

    Condition: {
        "Bool": {
        "kms:GrantIsForAWSResource: "true"
        }
    }
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> The key resource grant policy statement determines what users/roles have rights to list, create, and revoke grants on the provisioned CMK. Key grants are a way of providing usage of the CMK temporarily. A user/role that has key grant or resource rights is allowed to grant applications, services, or resources a limited time pass to use the CMK and then revoke that pass when the application, service, or resource has completed the operation that required access to the key. No other rights on the key are given unless the user/role is also added to one of the other key policy statement blocks also.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [key_grantees](key_grantees) within the modules variables.tf file

```terraform
variable "key_grantees" {
    type        = list
    description = "List of users/roles/accounts that will be granted permission to CreateGrant, ListGrants, and RevokeGrant on the provisioned KMS CMK."
    default     = []
}
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> You can not assign an IAM group as a policy principal, only IAM users/roles are allowed as policy principals.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [key_grantees](key_grantees) module variable within a projects root main.tf file

This variable and the corresponding key grant policy that is automatically generated by the module for resource grant permissions are affected by the `key_grant_resource_restriction` variable value. The `key_grant_resource_restriction` variable controls the inclusion or exclusion of a condition statement that conditionally gets applied to the CMK grant policy restricting the creation of grants only to AWS resources if the value of the variable is the default value of `true`.  Setting the variable value to false will exclude the condition from being applied to the grant policy during provisioning.

<br>

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    key_grantees = ["arn:aws:iam::123456789101:role/AWS-KMS-Grantee-Role"]

    // Default Variable setting
    # key_grant_resource_restriction = true
}
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> If the CMK that is being provisioned will be used in conjunction with a service-linked role, the `key_grant_resource_restriction` variable must be set to `false`. During the process of creating a service-linked role, the provisioner of the role must create a grant for the role. If the aws resource restriction condition is in place, then all requests to create a grant by a user, including an admin will fail, and will not be available to the role.

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [key_grant_resource_restriction](tfvar.name)

<br>

Specifies if the grant policy that will be created using the key_grantee list will be conditionally restricted to AWS resources. If grants are required for service-linked roles, this value needs to be set to false. Defaults to true.

<br>

This variable controls the inclusion or exclusion of a condition statement that conditionally gets applied to the CMK grant policy restricting the creation of grants only to AWS resources if the value of the variable is the default value of `true`.  Setting the variable value to false will exclude the condition from being applied to the grant policy during provisioning. When the value of this variable is set to false, then the following grant policy is generated instead of the policy referenced for the `key_grantees` variable description:

<br>

```yaml
Statement:
- Sid: "KeyGrantPolicy"
    Effect: Allow
    Principal:
    AWS:
        - "arn:aws:iam::123456789101:role/AWS-RDS-Service-Role"
        - "arn:aws:iam::123456789101:user/rnason"
    Action:
        - "kms:ListGrants"
        - "kms:CreateGrant"
        - "kms:RevokeGrant"
    Resources: "*"
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [key_grant_resource_restriction](key_grant_resource_restriction) within the modules variables.tf file

```terraform
variable "key_grant_resource_restriction" {
    type        = bool
    description = "Specifies if the grant policy that will be created using the key_grantee list will be conditionally restricted to AWS resources. If grants are required for service-linked roles, this value needs to be set to false. Defaults to true."
    default     = true
}


```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [key_grant_resource_restriction](key_grant_resource_restriction) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    key_grant_resource_restriction = false
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [policy](tfvar.name)

<br>

A valid custom policy JSON document resource. If a custom key policy is desired, an aws_iam_policy_document resource can be created and passed to the module. If the default 'AUTO_GENERATE' value is passed, then the module will use the key_owners, key_admins, key_users, and key_grantees variables to automatically generate a key policy that will be attached to the provisioned KMS CMK.

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> The `key_grant_resource_restriction` variable value is also evaluated during the automatic policy generation, and controls whether the KMS key grant policy will be restricted to only issuing grants to AWS resources, or not. The restriction will prevent the issuing of a key grant to any user or role and can only be issued instead by an AWS service or resource.

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [policy](policy) within the modules variables.tf file

```terraform
variable "policy" {
    type        = string
    description = "A valid custom policy JSON document resource. If a custom key policy is desired, an aws_iam_policy_document resource can be created and passed to the module. If the default 'AUTO_GENERATE' value is passed, then the module will use the key_owners, key_admins, key_users, and key_grantees variables to automatically generate a key policy that will be attached to the provisioned KMS CMK."
    default     = "AUTO_GENERATE"
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [policy](policy) module variable within a projects root main.tf file

```terraform
// Define a custom KMS key policy to use instead of auto generating one
data "aws_iam_policy_document" "custom_policy" {
  statement {
    sid = "CustomKeyPolicy"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789101:root"]
    }
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
      "kms:ListGrants",
      "kms:CreateGrant",
      "kms:RevokeGrant",
    ]
    resources = ["*"]
  }
}

// Create the CMK using the custom policy
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    policy = data.aws_iam_policy_document.custom_policy.json
}
```

<br><br><br>

## ![Optional_Variable](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/48/optional-shieldblock.png) &nbsp; [tags](tfvar.name)

<br>

Tags that will be applied to the provisioned KMS CMK.

<br>

This variable should contain a map of tags that will be assigned to the KMS CMK upon creation. Any tags contained within the `kms_tags` map variable will be passed to the module and automatically merged with a few tags that are also automatically created when the module is executed. The automatically generated tags are as follows:

* __Name__ - This tag is assigned the value from the `kms_key_alias_name` required variable that is passed during module execution
* __Created_By__ - This tag is assigned the value of the aws user that was used to execute the Terraform module to create the KMS CMK. It uses the Terraform `aws_caller_identity {}` data source provider to obtain the User_Id value. This tag will be ignored for any future executions of the module, ensuring that its value will not be changed after it's initial creation.
* __Creator_ARN__ - This tag is assigned the ARN value of the aws user that was used to execute the Terraform module to create the KMS CMK. It uses the Terraform `aws_caller_identity {}` data source provider to obtain the User_ARN value. This tag will be ignored for any future executions of the module, ensuring that its value will not be changed after it's initial creation.
* __Creation_Date__ - This tag is assigned a value that is obtained by the Terraform `timestamp()` function. This tag will be ignored for any future executions of the module, ensuring that its value will not be changed after it's initial creation.
* __Updated_On__ - This tag is assigned a value that is obtained by the Terraform `timestamp()` function. This tag will be updated on each future execution of the module to ensure that it's value displays the last `terraform apply` date.

<br><br>

![CMK_Tags_Example](images/tf_kms_tags.png)

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Declaration of [tags](tags) within the modules variables.tf file

```terraform
variable "tags" {
    type        = map
    description = "Tags that will be applied to the provisioned KMS CMK."
    default     = {
        Provisioned_By = "Terraform"
        Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
    }
}
```

<br><br>

### ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Setting the [tags](tags) module variable within a projects root main.tf file

```terraform
module "example" {
    source = "git@github.com:CloudMage-TF/AWS-KMS-Module?ref=v1.0.5"

    // Required Variables
    name        = "cmk/ebs"
    description = "Primary EBS Volume Encryption Key for the Production environment."


    // Optional Variables with module defined default values assigned
    tags = {
        Provisioned_By = "Terraform"
        Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
    }
}
```

<br><br><br>

# Module Example Usage

An example of how to use this module can be found within the `example` directory of this repository.

<br><br>

# Variables and TFVar Reference File Templates

The following code blocks can be used or appended to an existing `variables.tf` file or `terraform.tfvars` file respectively within the project root consuming this module. Optional Variables are commented out and have their values set to the default values defined in the module's variables.tf/terraform.tfvars respective file. If the values of any optional variables do not need to be changed, then they do not need to be redefined or included in the project root. If they do need to be changed, then add them to the root project and change the values according to the project requirements.

<br><br>

## ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Module [variables.tf](variables.tf) Reference File

```terraform
###########################################################################
# Required AWS-KMS-Module Module Vars:
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
# Optional AWS-KMS-Module Module Vars:
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
    default     = True
}
variable "policy" {
    type        = string
    description = "A valid custom policy JSON document resource. If a custom key policy is desired, an aws_iam_policy_document resource can be created and passed to the module. If the default 'AUTO_GENERATE' value is passed, then the module will use the key_owners, key_admins, key_users, and key_grantees variables to automatically generate a key policy that will be attached to the provisioned KMS CMK."
    default     = "AUTO_GENERATE"
}

variable "tags" {
    type        = map
    description = "Tags that will be applied to the provisioned KMS CMK."
    default     = {
        Provisioned_By = "Terraform"
        Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
    }
}
```

<br><br>

## ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Module [TFVars](TFVars) Reference File

```terraform
###########################################################################
# Required AWS-KMS-Module Module Vars:
#-------------------------------------------------------------------------#
# The following variables require consumer defined values to be provided. #
###########################################################################
name        = "Value Required"
description = "Value Required"


###########################################################################
# Optional AWS-KMS-Module Module Vars:
#-------------------------------------------------------------------------#
# The following variables have default values already set by the module.  #
# They will not need to be included in a project root module variables.tf #
# file unless a non-default value needs be assigned to the variable.      #
###########################################################################
# is_enabled                     = True
# enable_key_rotation            = True
# deletion_window_in_days        = 30
# key_usage                      = "ENCRYPT_DECRYPT"
# customer_master_key_spec       = "SYMMETRIC_DEFAULT"
# key_owners                     = []
# key_admins                     = []
# key_users                      = []
# key_grantees                   = []
# key_grant_resource_restriction = True
# policy                         = "AUTO_GENERATE"

# tags = {
#   Provisioned_By = "Terraform"
#   Module_GitHub_URL = "https://github.com/CloudMage-TF/AWS-KMS-Module.git"
}
```

<br><br>

# Module Outputs Reference File Templates

The template will finally create the following outputs that can be pulled and used in subsequent terraform runs via data sources. The outputs will be written to the Terraform state file. When using and calling the module within a root project, the output values of the module are available to the project root by simply referencing the module outputs from the root project `outputs.tf` file.

<br><br>

## ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Module [outputs.tf](outputs.tf) Reference File

```terraform
##############################################
# AWS-KMS-Module Available Module Outputs:
##############################################
output "key_id" {
    aws_kms_key.this.key_id
}
output "key_arn" {
    aws_kms_key.this.arn
}
output "alias_arn" {
    aws_kms_alias.this.arn
}
output "target_key_arn" {
    aws_kms_alias.this.target_key_arn
}
```

<br><br>

## ![Folder](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/opened_folder.png) &nbsp; Module Output Usage Reference File

```terraform
##############################################
# AWS-KMS-Module Module Output Usage:
##############################################
output "key_id" {
    value = module.example.key_id
}
output "key_arn" {
    value = module.example.key_arn
}
output "alias_arn" {
    value = module.example.alias_arn
}
output "target_key_arn" {
    value = module.example.target_key_arn
}
```

<br><br>

> ![Note](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/note.png) &nbsp; [__Note:__](Note) <br> When referencing the module outputs be sure that the output value contains the identifier given to the module call. As an example, if the module was defined as `module "example" {}` then the output reference would be constructed as `module.example.key_id`.

<br><br>

# Terraform Requirements

* [Terraform](https://www.terraform.io/)
* [GIT](https://git-scm.com/download/win)
* [AWS-Account](https://aws.amazon.com/)

<br><br>

# Recommended Terraform Utilities

* [Terraform for VSCode](https://github.com/mauve/vscode-terraform)
* [Terraform Config Inspect](https://github.com/hashicorp/terraform-config-inspect)

<br><br>

# Contacts and Contributions

This project is owned and maintained by [CloudMage-TF](https://github.com/CloudMage-TF)

<br>

To contribute, please:

* Fork the project
* Create a local branch
* Submit Changes
* Create A Pull Request

<br><br>

![CloudMage](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/32/logo.png) This document was created with ![CloudMage](https://cloudmage-images-public.s3.us-east-2.amazonaws.com/icons/cloudmage/16/heart.png) by the open source [MagicDoc](https://pypi.org/project/magicdoc/) project!
