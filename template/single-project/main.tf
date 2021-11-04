
variable "project-group" {
  type = string
}

variable "project-code" {
  type = string
}

# TODO: make this do something
variable "enable-harbor" {
  type = bool
  default = true
}

variable "enable-k8s-dev" {
  type = bool
  default = true
}

variable "enable-k8s-acc" {
  type = bool
  default = true
}

variable "enable-k8s-prod" {
  type = bool
  default = false
}

variable "users" {
  type = set(string)
}

locals {
  project-name = "${var.project-group}-${var.project-code}"
}

