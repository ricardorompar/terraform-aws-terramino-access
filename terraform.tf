terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.17.0"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.1"
    }
  }
}
#ojo ampw_QKzOEydA6E


provider "aws" {
  region = "us-east-2"
}


provider "vault" {
  address   = var.vault_addr
  namespace = "admin" # Set for HCP Vault
  token     = var.vault_token
}

provider "boundary" {
  addr                   = var.boundary_addr
  auth_method_id         = data.vault_kv_secret_v2.boundary_login.data["auth_method_id"]
  auth_method_login_name = data.vault_kv_secret_v2.boundary_login.data["username"]
  auth_method_password   = data.vault_kv_secret_v2.boundary_login.data["password"]
}