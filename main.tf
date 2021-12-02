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
    replicas = 3
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
              port = 8080
            }
            initial_delay_seconds = 15
            period_seconds        = 15
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 8080
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
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }
    # type = "ClusterIP"
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
              name = kubernetes_service.webapp.metadata.0.name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}

