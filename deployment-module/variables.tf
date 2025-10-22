# Copyright (c) 2022, 2024 Oracle Corporation and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "deploy_from_local" {}
variable "deploy_from_operator" {}
variable "keycloak_password" {}
variable "keycloak_user" {}
variable "pre_deployment_commands" {
  type    = list(string)
  default = []
}
variable "post_deployment_commands" {
  type    = list(string)
  default = []
}

variable "deployment_extra_args" {
  type    = list(string)
  default = []
}
variable "local_kubeconfig_path" {
  type    = string
  default = ""
}

variable "bastion_host" {}
variable "bastion_user" {}
variable "ssh_private_key" {}
variable "operator_host" {}
variable "operator_user" {}
