output "namespace" {
  description = "Kubernetes namespace"
  value       = kubernetes_namespace.app.metadata[0].name
}

output "backend_service_name" {
  description = "Backend service name"
  value       = kubernetes_service.backend.metadata[0].name
}

output "frontend_service_name" {
  description = "Frontend service name"
  value       = kubernetes_service.frontend.metadata[0].name
}

output "frontend_service_ip" {
  description = "Frontend LoadBalancer public IP"
  value       = kubernetes_service.frontend.status[0].load_balancer[0].ingress[0].ip
}

