output "vnet_id" {
  description = "VNet ID"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "VNet name"
  value       = azurerm_virtual_network.main.name
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = azurerm_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = azurerm_subnet.private[*].id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = azurerm_nat_gateway.main.id
}

output "public_nsg_id" {
  description = "Public Network Security Group ID"
  value       = azurerm_network_security_group.public.id
}

output "private_nsg_id" {
  description = "Private Network Security Group ID"
  value       = azurerm_network_security_group.private.id
}

