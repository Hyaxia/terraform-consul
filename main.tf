provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_namespace" "tfs" {
  metadata {
    name = "tfs" # terraform-sandbox
  }
}
resource "kubernetes_deployment" "webapp" {
  metadata {
    name      = "webapp"
    namespace = "tfs"
    labels = {
      app = "webapp"
    }
  }
  spec {
    replicas = var.webapp_replicas
    selector {
      match_labels = {
        app = "webapp"
      }
    }
    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }
      spec {
        container {
          image             = "golang-docker-example"
          name              = "webapp"
          image_pull_policy = "Never" # this is set so that kuberenetes wont try to download the image but use the localy built one
          liveness_probe {
            http_get {
              path = "/"
              port = var.webapp_port
            }
            initial_delay_seconds = 15
            period_seconds        = 15
          }

          readiness_probe {
            http_get {
              path = "/"
              port = var.webapp_port
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "webapp" {
  metadata {
    name      = "webapp"
    namespace = "tfs"
    labels = {
      app = "webapp_ingress"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.webapp.metadata.0.labels.app
    }
    port {
      port        = var.webapp_port
      target_port = var.webapp_port
      protocol    = "TCP"
    }
    type = "ClusterIP"
  }
}
resource "kubernetes_deployment" "gateway" {
  metadata {
    name      = "gateway"
    namespace = "tfs"
    labels = {
      app = "gateway"
    }
  }
  spec {
    replicas = var.gateway_replicas
    selector {
      match_labels = {
        app = "gateway"
      }
    }
    template {
      metadata {
        labels = {
          app = "gateway"
        }
      }
      spec {
        container {
          image             = "gateway"
          name              = "gateway"
          image_pull_policy = "Never" # this is set so that kuberenetes wont try to download the image but use the localy built one
          liveness_probe {
            http_get {
              path = "/health"
              port = var.gateway_port
            }
            initial_delay_seconds = 15
            period_seconds        = 15
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = var.gateway_port
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "gateway" {
  metadata {
    name      = "gateway"
    namespace = "tfs"
    labels = {
      app = "gateway_ingress"
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.gateway.metadata.0.labels.app
    }
    port {
      port        = var.gateway_port
      target_port = var.gateway_port
      protocol    = "TCP"
    }
    type = "NodePort"
  }
}
resource "kubernetes_ingress_v1" "main_ingress" {
  metadata {
    name      = "main-ingress"
    namespace = "tfs"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.gateway.metadata.0.name
              port {
                number = var.gateway_port
              }
            }
          }
        }
      }
    }
  }
}

