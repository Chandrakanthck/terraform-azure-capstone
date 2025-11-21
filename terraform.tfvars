# Azure Region
location = "southeastasia"

# Resource Group
resource_group_name = "rg-capstone-demo"

# Networking
vnet_cidr            = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

# AKS Configuration
cluster_name       = "aks-capstone-cluster"
kubernetes_version = "1.31.5"
node_count         = 2
min_size           = 2
max_size           = 5
node_vm_size       = "Standard_D2s_v3"

# Database Configuration
db_admin_username = "dbadmin"
db_admin_password = "SecurePass123!"
db_vm_size        = "Standard_B2s"
