
# dev 
provider "kubernetes" {
  config_path    = "~/.kube/tf-config"
  config_context = "gitlab-terraform"
  alias = "dev"
}

# acc
provider "kubernetes" {
  config_path    = "~/.kube/tf-config"
  config_context = "gitlab-terraform"
  alias = "acc"
}

# prod
provider "kubernetes" {
  config_path    = "~/.kube/tf-config"
  config_context = "gitlab-terraform"
  alias = "prod"
}

module "dev-namespace" {
  count = "${var.enable-k8s-dev ? 1 : 0}"
  source = "../../individual-entitlements/kubernetes-namespace"
  project-name = "${local.project-name}-dev"
  namespace-admins = var.users
  cluster-context = "rpi"
  providers = {
    kubernetes = kubernetes.dev
  }
}

module "test-namespace" {
  count = "${var.enable-k8s-acc ? 1 : 0}"
  source = "../../individual-entitlements/kubernetes-namespace"
  project-name = "${local.project-name}-acc"
  namespace-admins = var.users
  cluster-context = "rpi"
  providers = {
    kubernetes = kubernetes.acc
  }
}

module "prod-namespace" {
  count = "${var.enable-k8s-prod ? 1 : 0}"
  source = "../../individual-entitlements/kubernetes-namespace"
  project-name = "${local.project-name}-prod"
  namespace-admins = var.users
  cluster-context = "rpi"
  providers = {
    kubernetes = kubernetes.prod
  }
}
