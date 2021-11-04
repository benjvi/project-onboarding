
terraform {
  required_providers {
    harbor = {
      source = "BESTSELLER/harbor"
      version = "3.2.0"
    }
  }
}

variable "harbor_connection_password" {
 type = string
}

variable "harbor_connection_username" {
  type = string
  default = "admin"
}

# TODO: de-hardcode stuff like this
provider "harbor" {
  url      = "https://harbor.fly-env.fly.bjv.me"
  username = var.harbor_connection_username
  password = var.harbor_connection_password 
}

module "harbor-project" {
  source = "../../individual-entitlements/harbor"
  project-name = local.project-name
  users = var.users
}
