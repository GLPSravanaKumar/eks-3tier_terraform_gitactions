resource "kubernetes_deployment" "database" {
  metadata {
    name      = "database-deployment"
    namespace = kubernetes_namespace.ns.metadata[0].name
    labels = {
      app = "database"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "database"
      }
    }

    template {
      metadata {
        labels = {
          app = "database"
        }
      }

      spec {
        container {
          name  = "database"
          image = var.database_image

          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "root"
          }

          env {
            name  = "MYSQL_DATABASE"
            value = "app_db"
          }

          port {
            container_port = 3306
          }
          
        }
      }
    }
  }
}

resource "kubernetes_service" "database" {
  metadata {
    name      = "database-service"
    namespace = kubernetes_namespace.ns.metadata[0].name
  }

  spec {
    selector = {
      app = "database"
    }
    port {
      port        = 3306
      target_port = 3306
    }
    type = "ClusterIP"
  }
  depends_on = [kubernetes_deployment.database]
}
