[![GitHub release](https://img.shields.io/github/release/OlegGorj/tf-modules-aws-key-pair.svg)](https://github.com/OlegGorj/tf-modules-aws-key-pair/releases)
[![GitHub issues](https://img.shields.io/github/issues/OlegGorj/tf-modules-aws-key-pair.svg)](https://github.com/OlegGorj/tf-modules-aws-key-pair/issues)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/0c85a578cb0c4c85bddb373a6f3686ce)](https://app.codacy.com/app/oleggorj/tf-modules-aws-key-pair?utm_source=github.com&utm_medium=referral&utm_content=OlegGorj/tf-modules-aws-key-pair&utm_campaign=badger)

# Terraform Module: AWS SSH Key file

Terraform module for creating/registering Ssh key file

## Overview


### Prerequisites:


## How to use SSH Key module:

Example of `../environments/dev/dev.tfvars` file:

```bash
export ENVIRONMENT="dev"

export AWS_REGION="ca-central-1"
export AWS_PROFILE="default"

export AWS_STATE_BUCKET="tf-state-bucket"

```

Init terraform:

```bash

# example of usage is located under ./test directory
cd test

terraform init  \
    -backend-config="bucket=ca-central-1.aws-terraform-state-bucket" \
    -backend-config="key=terraform/dev/tf.tfstate" \
    -backend-config="region=ca-central-1" \
    -backend-config="profile=dev"  \
    -var-file=../environments/dev/dev.tfvars

```

Plan terraform:

```bash
terraform plan -var-file=../environments/dev/dev.tfvars -out=./terraform
```

Apply terraform:

```bash
terraform apply -var-file=../environments/dev/dev.tfvars
```



---
