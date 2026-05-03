terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# lokal kubeconfig verwenden, um sich mit dem Kubernetes-Cluster zu verbinden
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Namespace für die Sicherheitsinfrastruktur erstellen
resource "kubernetes_namespace" "sec_namespace" {
  metadata {
    name = "security-infra-tf"
    labels = {
      managed-by = "terraform"
      part-of    = "devsecops-platform"
    }
  }
}