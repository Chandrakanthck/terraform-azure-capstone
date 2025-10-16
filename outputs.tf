output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Resource group name"
}

output "aks_cluster_name" {
  value       = module.aks.cluster_name
  description = "AKS cluster name"
}

output "database_private_ip" {
  value       = module.database.private_ip
  description = "Database VM private IP"
}

output "frontend_service_ip" {
  value       = module.k8s_app.frontend_service_ip
  description = "Frontend LoadBalancer public IP"
}

output "kube_config_command" {
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${module.aks.cluster_name}"
  description = "Command to configure kubectl"
}

