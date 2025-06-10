##########################
#      SSH SIGNING       #
##########################

resource "vault_policy" "ssh_signer" {
  name   = "ssh"
  policy = file("acl_policies/ssh_policy.hcl")
}

resource "vault_policy" "boundary_controller" {
  name = "boundary-controller"

  policy = file("acl_policies/boundary_controller_policy.hcl")
}

resource "vault_mount" "ssh" {
  path        = "ssh-client-signer"
  type        = "ssh"
  description = "This is an example SSH Engine"

  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

# -----------------
# Vault CA

resource "vault_ssh_secret_backend_ca" "boundary" {
  backend              = vault_mount.ssh.path
  generate_signing_key = true
}

resource "vault_kv_secret_v2" "vault_ca" {
  mount = "secrets"
  name  = "vault-ca"
  data_json = jsonencode({
    ca_public_key = "${vault_ssh_secret_backend_ca.boundary.public_key}"
  })
}

resource "vault_token" "boundary_token" {
  no_default_policy = true
  period            = "24h"
  policies          = ["boundary-controller", "ssh"]
  no_parent         = true
  renewable         = true

  renew_min_lease = 43200
  renew_increment = 86400

  metadata = {
    "purpose" = "service-account-boundary"
  }
}

resource "vault_ssh_secret_backend_role" "signer" {
  backend                 = vault_mount.ssh.path
  name                    = "boundary-client"
  key_type                = "ca"
  allow_user_certificates = true
  default_user            = "ubuntu"
  default_extensions = {
    "permit-pty" : ""
  }
  allowed_users      = "*"
  allowed_extensions = "*"
}

##########################
#    READING SECRETS     #
##########################
locals {
  kv_mount = "secrets"
}

data "vault_kv_secret_v2" "boundary_login" {
  mount = local.kv_mount
  name  = "boundary_login"
}

data "vault_kv_secret_v2" "terramino" {
  mount = local.kv_mount
  name  = "terramino"
}