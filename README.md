[200~# Azure Kubernetes Service (AKS) - Terraform Infrastructure as Code

!Azure
!Terraform
!Kubernetes
!Status

**Production-grade 3-tier application infrastructure on Microsoft Azure using Terraform and Azure Kubernetes Service (AKS)**

📌 **Live Demo:** `http://57.158.173.19` *(Deployment may be terminated to save costs)*

---

## 🎯 Project Overview

This project demonstrates **Infrastructure as Code (IaC)** best practices by deploying a complete 3-tier application on Azure:

- **Presentation Tier:** Frontend pods with Azure Load Balancer
- **Application Tier:** Backend API pods in Kubernetes
- **Data Tier:** MariaDB database on dedicated Azure VM in private subnet

### ✅ Key Features

- **Modular Terraform Design** - Reusable infrastructure modules
- **Auto-scaling AKS Cluster** - 2-5 nodes based on demand
- **Secure Networking** - VNet with public/private subnets, NSG rules, NAT Gateway
- **High Availability** - Multiple pod replicas with LoadBalancer
- **GitOps Workflow** - Version-controlled infrastructure

---

## 🏗️ Architecture

┌─────────────────────────────────────────────────────────────┐
│ Azure Cloud │
├─────────────────────────────────────────────────────────────┤
│ ┌────────────────────────────────────────────────────┐ │
│ │ Virtual Network (10.0.0.0/16) │ │
│ │ ┌──────────────┐ ┌──────────────┐ │ │
│ │ │ Public Subnet│ │Private Subnet│ │ │
│ │ │ 10.0.1.0/24 │ │ 10.0.3.0/24 │ │ │
│ │ │ │ │ │ │ │
│ │ │ LoadBalancer │───────>│ AKS Cluster │ │ │
│ │ │ (Public IP) │ │ 2-5 Nodes │ │ │
│ │ └──────────────┘ └──────┬───────┘ │ │
│ │ │ │ │
│ │ ┌───────▼───────┐ │ │
│ │ │Private Subnet │ │ │
│ │ │ 10.0.4.0/24 │ │ │
│ │ │ MariaDB VM │ │ │
│ │ │ 10.0.4.4 │ │ │
│ │ └───────────────┘ │ │
│ └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘

text

---

## 📦 Infrastructure Components

| Component | Azure Service | Specification |
|-----------|---------------|---------------|
| **Region** | Southeast Asia | `southeastasia` |
| **AKS Cluster** | Kubernetes v1.30 | 2 nodes (auto-scale 2-5) |
| **Node Size** | Virtual Machine | `Standard_D2s_v3` |
| **Virtual Network** | VNet | `10.0.0.0/16` (4 subnets) |
| **Database** | Ubuntu 22.04 VM | MariaDB on `Standard_B2s` |
| **Application** | Kubernetes Pods | 2 frontend + 2 backend |
| **Load Balancer** | Azure Standard LB | Public IP exposed |

---

## 📂 Project Structure

terraform-azure-capstone/
├── main.tf # Root Terraform configuration
├── variables.tf # Input variable definitions
├── outputs.tf # Output value definitions
├── terraform.tfvars # Variable values (gitignored)
├── .gitignore # Git ignore patterns
├── README.md # Project documentation
└── modules/ # Terraform modules
├── vnet/ # Virtual Network module
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
├── aks/ # AKS Cluster module
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
├── database/ # Database VM module
│ ├── main.tf
│ ├── variables.tf
│ └── output.tf
└── k8s_app/ # Kubernetes application module
├── main.tf
├── variables.tf
└── output.tf

text

---

## 🚀 Quick Start

### Prerequisites

- **Azure CLI** - Install
- **Terraform** ≥ 1.12 - Install
- **kubectl** - Auto-installed with AKS credentials
- **Git** - Install

### Deployment Steps

#### 1️⃣ Clone Repository

git clone https://github.com/Chandrakanthck/terraform-azure-capstone.git
cd terraform-azure-capstone

text

#### 2️⃣ Configure Variables

Create `terraform.tfvars`:

Azure Region
location = "southeastasia"

Resource Group
resource_group_name = "rg-capstone-demo"

Networking
vnet_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

AKS Configuration
cluster_name = "aks-capstone-cluster"
kubernetes_version = "1.30"
node_count = 2
min_size = 2
max_size = 5
node_vm_size = "Standard_D2s_v3"

Database Configuration
db_admin_username = "dbadmin"
db_admin_password = "YourSecurePassword123!" # Change this!
db_vm_size = "Standard_B2s"

text

#### 3️⃣ Azure Authentication

az login
az account show --output table
az account set --subscription "Azure for Students"

text

#### 4️⃣ Deploy Infrastructure

Initialize Terraform
terraform init

Validate configuration
terraform validate

Create execution plan
terraform plan -out=tfplan

Apply changes (deploys in ~5 minutes)
terraform apply tfplan

text

#### 5️⃣ Access Kubernetes

Get AKS credentials
az aks get-credentials
--resource-group rg-capstone-demo
--name aks-capstone-cluster
--overwrite-existing

Verify cluster
kubectl get nodes
kubectl get pods -n capstone
kubectl get svc -n capstone

text

#### 6️⃣ Test Application

Get LoadBalancer IP
FRONTEND_IP=$(kubectl get svc frontend-service -n capstone
-o jsonpath='{.status.loadBalancer.ingress.ip}')

echo "Application URL: http://$FRONTEND_IP"

Test endpoint
curl http://$FRONTEND_IP

Expected: "Backend is running! Connected to database at 10.0.4.4"
text

---

## 🧹 Cleanup

**⚠️ Important:** Always destroy resources to avoid unexpected charges!

### Method 1: Terraform Destroy

cd terraform-azure-capstone
terraform destroy -auto-approve

text

### Method 2: Azure CLI

az group delete --name rg-capstone-demo --yes --no-wait
az group delete --name MC_rg-capstone-demo_aks-capstone-cluster_southeastasia --yes --no-wait

text

### Method 3: Azure Portal

1. Go to portal.azure.com
2. Navigate to **Resource groups**
3. Delete `rg-capstone-demo`
4. Delete `MC_rg-capstone-demo_aks-capstone-cluster_southeastasia`

---

## 💰 Cost Estimation

### Full Configuration (24/7)

| Resource | Cost/Month | Percentage |
|----------|------------|------------|
| AKS Nodes (2x Standard_D2s_v3) | $158 | 70% |
| Database VM (Standard_B2s) | $29 | 13% |
| NAT Gateway | $32 | 14% |
| Public IPs | $3 | 1% |
| Storage | $5 | 2% |
| **Total** | **~$228** | **100%** |

### 💡 Cost Optimization Tips

1. **Reduce node count:** Use 1 node instead of 2 → Save 50%
2. **Smaller VMs:** Use `Standard_B2s` nodes → Save 70%
3. **Session-based:** Deploy only when testing → $1.50-2.00 per session

**Best for learning:** Deploy → Test (2-3 hours) → Destroy  
**$100 credits = 50-60 learning sessions!**

---

## 🛠️ Troubleshooting

### Issue: Region Not Allowed

**Error:** `RequestDisallowedByAzure: Resource was disallowed by Azure`

**Solution:**
Check allowed regions
az account list-locations --query "[?metadata.regionCategory=='Recommended'].name" -o table

Update location in terraform.tfvars
location = "southeastasia" # or another allowed region

text

### Issue: LoadBalancer IP Pending

**Symptom:** External IP shows `<pending>`

**Solution:**
- Wait 2-3 minutes for Azure to provision
- Check NSG rules allow LoadBalancer traffic
- Verify AKS cluster permissions

kubectl describe svc frontend-service -n capstone
kubectl get events -n capstone --sort-by='.lastTimestamp'

text

### Issue: Pods Not Starting

**Solution:**
Check pod details
kubectl describe pod <pod-name> -n capstone

Check logs
kubectl logs <pod-name> -n capstone

Check events
kubectl get events -n capstone

text

---

## 📚 Documentation

- **Terraform Azure Provider:** Documentation
- **Azure AKS:** Documentation
- **Kubernetes:** Documentation

---

## 🎓 What I Learned

- ✅ Terraform Infrastructure as Code principles
- ✅ Azure cloud services (AKS, VNet, NSG, NAT Gateway)
- ✅ Kubernetes deployment and service management
- ✅ Multi-tier application architecture
- ✅ Cloud security best practices
- ✅ Cost optimization strategies
- ✅ GitOps workflows

---

## 🤝 Contributing

This is a personal learning project, but suggestions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Commit changes (`git commit -m 'Add improvement'`)
4. Push to branch (`git push origin feature/improvement`)
5. Open a Pull Request

---

## 📝 License

This project is open source and available for educational purposes.

---

## 👤 Author

**Chandrakanth**

- 📧 Email: chandugodasi@outlook.com
- 💼 GitHub: @Chandrakanthck
- 🌐 Project Link: terraform-azure-capstone

---

## 🙏 Acknowledgments

- **Microsoft Azure** - Cloud platform and Azure for Students program
- **HashiCorp** - Terraform IaC tool
- **Kubernetes Community** - Container orchestration platform
- **GitHub** - Version control and hosting

---

## 📊 Project Status

✅ Infrastructure deployed and tested
✅ Application running successfully
✅ Documentation complete
✅ Cost optimization implemented
✅ Repository published

text

**Last Updated:** October 16, 2025

---

<div align="center">

### ⭐ Star this repository if you found it helpful!

**Made with ❤️ for learning and sharing knowledge**

</div>
