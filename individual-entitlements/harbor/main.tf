terraform {
  required_providers {
    harbor = {
      source = "BESTSELLER/harbor"
      version = "3.2.0"
    }
  }
}

variable "project-name" {
  type = string
}

variable "users" {
  type = set(string)
}

variable "storage_quota" {
  type = string
  default = "20"
}

resource "harbor_project" "project" {
  name                    = var.project-name
  public                  = false
  vulnerability_scanning  = true                # automatically scan images on push 
  enable_content_trust    = true                # allow unsigned images from being pulled 
  storage_quota = var.storage_quota
}

resource "harbor_project_member_user" "masters" {
  for_each = var.users
  project_id = harbor_project.project.id
  user_name = each.value
  role = "master"
}

resource "harbor_retention_policy" "project" {
    scope = harbor_project.project.id
    schedule = "daily"
    rule {
        n_days_since_last_pull = 180
        repo_matching = "**"
        tag_excluding = "prod"
    }
}
