terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "terramino" {
  source               = "../"
  org_id               = var.org_id
  project_id           = var.project_id
  waypoint_application = var.waypoint_application
  port                 = var.port
  client_id            = var.client_id
  client_secret        = var.client_secret
}