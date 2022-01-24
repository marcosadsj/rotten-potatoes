terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.17.0"
    }
  }
}

provider "digitalocean" {
  # Configuration options
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s-kubedev" {
  name   = var.name_cluster
  region = "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.21.5-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

variable "do_token" {}
variable "name_cluster" {}

output "kubernetes_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s-kubedev.endpoint
}

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.k8s-kubedev.kube_config.0.raw_config
  filename = "kube_config.yaml"
}
