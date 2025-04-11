variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "org_id" {
  type = string
}

variable "project_id" {
  type = string
}

variable "waypoint_application" {
  type = string
}

variable "port" {
  type    = number
  default = 80
}

variable "vault_token_boundary" {
  description = "The token to authenticate with Vault with the Boundary controller policy. Already configured in HCP Terraform"
  type        = string
}

variable "vault_token_admin" {
  description = "The token to authenticate with Vault with the admin policy."
  type        = string
}

variable "vault_addr" {
  description = "The address of my Vault cluster running in HCP."
  type        = string
}

variable "username" {
  description = "Username for userpass auth-method in Boundary."
  type        = string
}

variable "password" {
  description = "Password for userpass auth-method in Boundary."
  type        = string
}

variable "auth_method_id" {
  description = "The ID of the auth-method in Boundary."
  type        = string
}

variable "boundary_addr" {
  description = "The address of my Boundary cluster running in HCP."
  type        = string
}