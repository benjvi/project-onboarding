
variable "project-name" {
  type = string
}

variable "namespace-admins" {
  type = set(string)
}

variable "cpu_request_total_quota" {
  type = string
  default = "500m"
}

variable "memory_request_total_quota" {
  type = string
  default = "1Gi"
}

variable "cluster-context" {
  type = string
}

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.1"
    }
  }
}


resource "kubernetes_namespace" "project-ns" {
  metadata {
    name = var.project-name
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_role_binding" "namespace-admins" {
  metadata {
    name = "namespace-admins"
    namespace = kubernetes_namespace.project-ns.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "admin"
  }
  dynamic "subject" {
    for_each  = var.namespace-admins
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

resource "kubernetes_limit_range" "project-default-requests" {
  metadata {
    name = "default-requests"
    namespace = kubernetes_namespace.project-ns.metadata[0].name
  }
  spec {
    limit {
      type = "Container"
      default_request = {
        cpu    = "1m"
        memory = "1Mi"
      }
    }
  }
}

resource "kubernetes_resource_quota" "project-total-requests" {
  metadata {
    name = "total-requests-allowed"
    namespace = kubernetes_namespace.project-ns.metadata[0].name
  }
  spec {
    hard = {
      cpu = var.cpu_request_total_quota
      memory = var.memory_request_total_quota
    }
  }
}


