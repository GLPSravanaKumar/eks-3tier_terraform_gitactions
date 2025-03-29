resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name = "app-ingress"
    annotations = {
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
      "alb.ingress.kubernetes.io/listen-ports" = "[{\"HTTP\": 80}]"
      "kubernetes.io/ingress.class" = "alb"
    }
  }

  spec {
    rule {
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.frontend.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }

        path {
          path     = "/api"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.backend.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }
      }
    }
  }
}
