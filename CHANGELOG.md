<!-- VSCode Markdown Exclusions-->
<!-- markdownlint-disable MD024 Multiple Headings with the Same Content-->
# CloudMage TF-AWS-KMS-Module CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<br>

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
