# CloudMage TF-AWS-KMS-Module CHANGELOG

This file is used to list changes made in each version update of the CloudMage Terraform Module:

> TF-AWS-KMS-Module

<br>

## 1.0.2 (2019-10-15)

- Added kms_owner_principal_list variable to add the ability to customize the key owner.

<br>

## 1.0.1 (2019-10-3)

- Previous version of the module was returning a single string of comma separated values if multiple ARNs were provided to the optional params. Replaced the if/then with a conditional to correct the issue

<br>

## 1.0.0 (2019-09-22)

- Functional module initial commit
