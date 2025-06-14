
data "boundary_scope" "org" {
  name     = var.boundary_org_name
  scope_id = "global"
}

resource "random_pet" "unique" {
  length = 1
}
/* Create a project scope within the organization
Each org can contain multiple projects and projects are used to hold
infrastructure-related resources
*/
resource "boundary_scope" "project" {
  name                     = "Demo project ${random_pet.unique.id}"
  description              = "Project to hold the resources for SSH demo"
  scope_id                 = data.boundary_scope.org.id
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_credential_store_vault" "vault" {
  name        = "certificates-store-${random_pet.unique.id}"
  description = "Vault credential store!"
  address     = var.vault_addr
  token       = vault_token.boundary_token.client_token
  scope_id    = boundary_scope.project.id
  namespace   = "admin"
}

resource "boundary_credential_library_vault_ssh_certificate" "ssh" {
  name                = "certificates-library"
  description         = "Certificate Library"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "ssh-client-signer/sign/boundary-client" # change to Vault backend path
  username            = "ubuntu"
  key_type            = "ecdsa"
  key_bits            = 521

  extensions = {
    permit-pty = ""
  }
}

resource "boundary_host_catalog_static" "aws_instance" {
  name        = "ssh-catalog"
  description = "SSH catalog"
  scope_id    = boundary_scope.project.id
}

resource "boundary_host_static" "ssh" {
  name            = "ssh-host"
  host_catalog_id = boundary_host_catalog_static.aws_instance.id
  address         = aws_instance.web.public_ip
}

resource "boundary_host_set_static" "ssh" {
  name            = "ssh-host-set"
  host_catalog_id = boundary_host_catalog_static.aws_instance.id

  host_ids = [
    boundary_host_static.ssh.id
  ]
}


resource "boundary_target" "ssh" {
  type                     = "ssh"
  name                     = "terramino-ssh"
  description              = "SSH target to the host running Terramino"
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  host_source_ids = [
    boundary_host_set_static.ssh.id
  ]

  # Comment this to avoid brokering the credentials

  injected_application_credential_source_ids = [
    boundary_credential_library_vault_ssh_certificate.ssh.id
  ]

}

resource "boundary_alias_target" "ssh" {
  name           = "terramino-ssh-alias-${random_pet.unique.id}"
  description    = "Alias for the SSH target"
  scope_id       = "global"
  value          = "ssh.terramino.${random_pet.unique.id}"
  destination_id = boundary_target.ssh.id
  #authorize_session_host_id = boundary_host_static.bar.id
}