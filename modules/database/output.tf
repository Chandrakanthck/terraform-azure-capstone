output "vm_id" {
  description = "Database VM ID"
  value       = azurerm_linux_virtual_machine.db.id
}

output "vm_name" {
  description = "Database VM name"
  value       = azurerm_linux_virtual_machine.db.name
}

output "private_ip" {
  description = "Database VM private IP address"
  value       = azurerm_network_interface.db.private_ip_address
}

output "admin_username" {
  description = "Database admin username"
  value       = var.admin_username
}

