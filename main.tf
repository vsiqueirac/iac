terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "k8s_iniciativa" {
  name = var.k8s_name
  region = var.region
  version = "1.23.9-do.0"
  node_pool {
    name = "default"
    size = "s-1vcpu-2gb"
    node_count = 2
  }
}

output "kube_endpoint" {
  value=digitalocean_kubernetes_cluster.k8s_iniciativa.endpoint
}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
    filename = "kube_config.yaml"
}
