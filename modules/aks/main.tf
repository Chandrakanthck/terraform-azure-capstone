# AKS Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.cluster_name}-dns"
  kubernetes_version  = var.kubernetes_version

  # Default Node Pool (System mode)
  default_node_pool {
    name                = "system"
    node_count          = var.node_count
    vm_size             = var.node_vm_size
    vnet_subnet_id      = var.vnet_subnet_id
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 5
    os_disk_size_gb     = 50

    # Node labels
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "capstone"
    }

    tags = {
      Environment = "Capstone"
      NodePool    = "System"
    }
  }

  # Identity for AKS
  identity {
    type = "SystemAssigned"
  }

  # Network Profile
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "172.16.0.0/16"
    dns_service_ip    = "172.16.0.10"
  }

  # RBAC
  role_based_access_control_enabled = true

  tags = {
    Environment = "Capstone"
    ManagedBy   = "Terraform"
  }
}

# Role Assignment - Allow AKS to manage network resources
resource "azurerm_role_assignment" "aks_network" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

