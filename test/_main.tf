###############################################################################
# variables
###############################################################################
variable "region" {}
variable "env" {}
variable "account_id" {}
variable "key_path" {}
variable "key_name" {}
variable "ec2_bastion_instance_type" {}
variable "ec2_bastion_user" {}
variable "state_bucket" {}
variable "kms_key_id" {}
variable "ip_allow1" {}
variable "ip_allow2" {}
variable "ip_allow3" {}
variable "ip_allow4" {}
variable "ip_allow5" {}

variable "cred-file" {
  default = "~/.aws/credentials"
}

variable "namespace" {
  default = "awscloud.io"
}
variable "name" {
  default = "testkey"
}

###############################################################################
# RESOURCES
###############################################################################
terraform {
  backend "s3" {
    encrypt = true
    acl     = "private"
  }
}

provider "aws" {
  region                   = "${var.region}"
  shared_credentials_file  = "${var.cred-file}"
  profile                  = "${var.env}"
}

module "ssh_key_pair" {
  source    = "git::https://github.com/OlegGorj/tf-modules-aws-key-pair.git?ref=dev-branch"
  namespace = "${var.namespace}"
  stage     = "${var.env}"
  name      = "${var.name}"
  ssh_public_key_path   = "~/Downloads"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
}
