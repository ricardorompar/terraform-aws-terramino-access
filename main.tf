data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Retrieve Vault CA
data "vault_kv_secret_v2" "vault_ca" {
  mount = "secrets"
  name  = "vault-ca"
}

data "cloudinit_config" "content" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "ca-config.sh"
    content_type = "text/x-shellscript"

    content = templatefile("ca-config.sh", {
      ca_public_key = data.vault_kv_secret_v2.vault_ca.data["ca_public_key"]
    })
  }

  part {
    filename     = "boot.sh"
    content_type = "text/x-shellscript"

    content = templatefile("boot.sh", {
      client_id     = var.client_id,
      client_secret = var.client_secret,
      org_id        = var.org_id,
      project_id    = var.project_id,
      app_name      = var.waypoint_application,
      port          = var.port
    })
  }
}

resource "aws_instance" "web" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.small"
  security_groups = [aws_security_group.allow_web_traffic.name]
  key_name        = aws_key_pair.ssh_key_pair.key_name

  user_data                   = data.cloudinit_config.content.rendered
  user_data_replace_on_change = true

  tags = {
    Name = "terramino-${var.waypoint_application}"
  }
}
