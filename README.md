# Terramino Terraform module

This Terraform module creates an instance of [terramino-go](https://github.com/hashicorp-education/terramino-go) running on an EC2 instance in AWS. It takes in the following Terraform variables to configure the application to read Redis connection information from HashiCorp Vault Secrets.

- `client_id`
- `client_secret`
- `org_id`
- `project_id`

## Boundary connection
Apart from the template configuration, the `main.tf` file was modified to retrieve and install the `vault-ca` public key in the EC2.
This is required to use Boundary with SSH credential injection.