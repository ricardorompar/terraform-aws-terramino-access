# Terramino Terraform module

This Terraform module creates an instance of [terramino-go](https://github.com/hashicorp-education/terramino-go) running on an EC2 instance in AWS. It takes in the following Terraform variables to configure the application to read Redis connection information from HashiCorp Vault Secrets.

- `client_id`
- `client_secret`
- `org_id`
- `project_id`

- `vault_token`
- `vault_addr`
- `username`: login name for Boundary userpass auth-method.
- `password`: password for Boundary userpass auth-method.

## Boundary connection
Apart from the template configuration, the `main.tf` file was modified to retrieve and install the `vault-ca` public key in the EC2.
This is required to use Boundary with SSH credential injection.

## Prerequisites

- AWS account with appropriate permissions
- Terraform installed (version 0.14 or higher recommended)
- HashiCorp Vault instance configured with Redis connection information
- HashiCorp Boundary cluster configured with a userpass auth method

>In order to retrieve the `auth_method_id` you can run the following command in a terminal connected to your Boundary cluster:
    ```bash
    boundary auth-methods list -format json | jq -r '.items[] | select(.type=="password") | .id' 
    ```

## Usage

```hcl
module "terramino" {
    source          = "github.com/hashicorp-education/terraform-aws-terramino"
    
    # HCP Vault configuration
    vault_addr      = "https://vault-cluster.vault.11xx22.aws.hashicorp.cloud:8200"
    vault_token     = var.vault_token
    
    # Boundary configuration
    username        = "boundary-user"
    password        = var.boundary_password
    auth_method_id  = var.auth_method_id
    
    # HCP credentials
    client_id       = var.client_id
    client_secret   = var.client_secret
    org_id          = var.org_id
    project_id      = var.project_id
}
```

## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | ID of the EC2 instance running Terramino |
| `public_ip` | Public IP address of the EC2 instance |
| `application_url` | URL to access the Terramino game |

## Architecture

This module deploys the Terramino game on an EC2 instance and configures it to:
1. Retrieve Redis connection details from HashiCorp Vault
2. Set up authentication with HashiCorp Boundary for secure SSH access
3. Install necessary certificates for secure communication

## Testing

After deployment, you can:
1. Access the game through the provided application_url
2. Connect to the instance via Boundary using SSH credential injection
3. Verify logs using `journalctl -u terramino`
