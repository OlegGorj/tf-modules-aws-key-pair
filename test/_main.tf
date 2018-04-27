###############################################################################
# variables
###############################################################################
variable "region" {}
variable "env" {}
variable "key_path" {}
variable "key_name" {}
variable "state_bucket" {}

variable "cred-file" {
  default = "~/.aws/credentials"
}

variable "namespace" {
  default = "privatenamespace"
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
  ssh_public_key_path   = "/Users/oleggorj/Downloads/"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
}
