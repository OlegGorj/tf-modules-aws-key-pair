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
  default = "testcluster"
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


#resource "aws_key_pair" "key" {
#  key_name   = "${var.key_name}"
#  public_key = "${file("~/.ssh/dev_key.pub")}"
#}
