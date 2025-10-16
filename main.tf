terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# VNet Module
module "vnet" {
  source               = "./modules/vnet"
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  vnet_cidr            = var.vnet_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# AKS Module
module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  vnet_subnet_id      = module.vnet.private_subnet_ids[0]
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
}

# Database Module
module "database" {
  source              = "./modules/database"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.vnet.private_subnet_ids[1]
  admin_username      = var.db_admin_username
  admin_password      = var.db_admin_password
  vm_size             = var.db_vm_size
}

# Configure Kubernetes provider
provider "kubernetes" {
  host                   = module.aks.kube_config.0.host
  client_certificate     = base64decode(module.aks.kube_config.0.client_certificate)
  client_key             = base64decode(module.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config.0.cluster_ca_certificate)
}

# K8s App Module
module "k8s_app" {
  source      = "./modules/k8s_app"
  namespace   = "capstone"
  db_host     = module.database.private_ip
  db_username = var.db_admin_username
  db_password = var.db_admin_password

  depends_on = [module.aks]
}

