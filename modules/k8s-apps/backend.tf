resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend-deployment"
    namespace = "default"
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name  = "backend"
          image = var.backend_image
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "backend"
    }
    port {
      port        = 5000
      target_port = 5000
    }
    type = "ClusterIP"
  }
}
