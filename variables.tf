variable "app_name" {
  type = string
}

variable "port" {
  type    = number
  default = 80
}

##########################
#        BOUNDARY        #
##########################
variable "boundary_org_name" {
  description = "The name of the Boundary organization."
  type        = string
  default     = "r2-org"
}

variable "boundary_addr" {
  description = "The address of my Boundary cluster running in HCP."
  type        = string
}

##########################
#          VAULT         #
##########################
variable "vault_token" {
  description = "The token to authenticate with Vault with the admin policy."
  type        = string
}

variable "vault_addr" {
  description = "The address of my Vault cluster running in HCP."
  type        = string
}