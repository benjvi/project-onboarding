
terraform {
  required_providers {
    harbor = {
      source = "BESTSELLER/harbor"
      version = "3.2.0"
    }
  }
}



variable "harbor_connection_username" {
  type = string
  default = "admin"
}

# for more convenience, suggest to set this in env with TF_VAR_harbor_connection_password
variable "harbor_connection_password" {
 type = string
}

# for more convenience, suggest to set this in env with TF_VAR_harbor_connection_password
variable "harbor_url" {
  type = string
}

provider "harbor" {
  url      = var.harbor_url
  username = var.harbor_connection_username
  password = var.harbor_connection_password 
}

module "harbor-project" {
  source = "../../individual-entitlements/harbor"
  project-name = local.project-name
  users = var.users
}
