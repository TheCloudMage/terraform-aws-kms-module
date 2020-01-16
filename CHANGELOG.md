# CloudMage TF-AWS-KMS-Module CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<br>

## 1.0.2 - [2019-10-15]

### Added

- Added kms_owner_principal_list variable to add the ability to customize the key owner.

### Changed

- Readme Updated

### Removed

- None

<br><br>

## 1.0.1 - [2019-10-3]

<!-- markdownlint-disable MD024 -->
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
