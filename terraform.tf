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
  address   = "https://hashicardo-vault-cluster-public-vault-ae5dfd09.d6efb4c3.z1.hashicorp.cloud:8200"
  namespace = "admin" # Set for HCP Vault
  token     = var.vault_token_admin
}

provider "boundary" {
  addr                   = "https://0b93a748-8e25-4330-b7cc-8ea5cc845155.boundary.hashicorp.cloud"
  auth_method_id         = var.auth_method_id
  auth_method_login_name = var.username
  auth_method_password   = var.password
}