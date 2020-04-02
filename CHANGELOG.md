<!-- VSCode Markdown Exclusions-->
<!-- markdownlint-disable MD024 Multiple Headings with the Same Content-->
# CloudMage TF-AWS-KMS-Module CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<br>

## v1.0.5 - [2020-04-1]

### Added

- Additional variable __is_enabled__ added and updated in corresponding module resource
- Additional variable __enable_key_rotation__ added and updated in corresponding module resource
- Additional variable __deletion_window_in_days__ added and updated in corresponding module resource
- Additional variable __key_usage__ added and updated in corresponding module resource
- Additional variable __customer_master_key_spec__ added and updated in corresponding module resource
- Additional variable __key_grant_resource_restriction__ added and updated in corresponding module resource
- Additional variable __policy__ added and updated in corresponding module resource
- Added value check for var.policy to allow module consumer to provide a custom policy instead of using the auto-generated one
- Added __target_key_arn__ aws_kms_alias output
- Descriptions added to each output

### Changed

- Variable names renamed to match terraform provisioner names. Renames listed individually below
  - Variable __kms_key_alias_name__ renamed => __name__
  - Variable __kms_key_description__ renamed => __description__
  - Variable __kms_owner_principal_list__ renamed => __key_owners__
  - Variable __kms_admin_principal_list__ renamed => __key_admins__
  - Variable __kms_user_principal_list__ renamed => __key_users__
  - Variable __kms_resource_principal_list__ renamed => __key_grantees__
  - Variable __kms_tags__ renamed => __tags__
- Output names renamed to match terraform provisioner names unless multiple resources share the same name. Renames Listed below
  - Output __kms_key_id__ renamed => __key_id__
  - Output __kms_key_arn__ renamed => __key_arn__
  - Output __kms_key_alias__ renamed => __alias_arn__
- Grant policy refactored slightly to make the restrict to aws resource restriction optional
- Updated Variable descriptions
- Example code updated to utilize new module version
- Updated Readme with MagicDoc

### Removed

- None

<br><br>

## v1.0.4 - [2020-01-23]

### Added

- None

### Changed

- Provisoned_By tag spelling corrected to Provisioned_By
- Fixed all Documentation to address miss-spelled tag

### Removed

- None

<br><br>

## 1.0.3 - [2020-01-21]

### Added

- Added kms_tags variable to allow the inclusion of tags when provisioning a CMK.
- Added merge to passed tags to also create Name, Created_By, Creator_ARN, Creation_Date and Updated_On auto tags.
- Lifecycle ignore_changes placed on Created_By, Creator_ARN, and Creation_Date auto tags.
- Updated_On tag unlike the others will automatically update on subsequent terraform apply executions.
- Added tags variable, and set value in example variables.tf and env.tfvars

### Changed

- Readme Updated to reflect tagging vars and process.
- Spacing for variables, outputs examples all set for consistency

### Removed

- None

<br><br>

## 1.0.2 - [2019-10-15]

### Added

- Added kms_owner_principal_list variable to add the ability to customize the key owner.
- Added `example` folder with project root example calling the module.

### Changed

- Readme Updated

### Removed

- None

<br><br>

## 1.0.1 - [2019-10-3]

### Added

- Previous version of the module was returning a single string of comma separated values if multiple ARNs were provided to the optional params. Replaced the if/then with a conditional to correct the issue

### Changed

- None

### Removed

- None

<br><br>

## [Unreleased] - [2019-09-22]

### Added

- Functional module initial commit
