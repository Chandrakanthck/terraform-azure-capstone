# Network Interface for Database VM
resource "azurerm_network_interface" "db" {
  name                = "nic-db-vm"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = "Capstone"
    Role        = "Database"
  }
}

# Database VM (Linux with MariaDB)
resource "azurerm_linux_virtual_machine" "db" {
  name                = "vm-mariadb"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.db.id
  ]

  os_disk {
    name                 = "osdisk-db"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Custom data to install and configure MariaDB
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    
    # Update system
    apt-get update -y
    
    # Install MariaDB Server
    DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server
    
    # Start and enable MariaDB
    systemctl start mariadb
    systemctl enable mariadb
    
    # Configure MariaDB to listen on all interfaces
    sed -i 's/bind-address.*=.*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
    
    # Restart MariaDB to apply changes
    systemctl restart mariadb
    
    # Secure MariaDB installation and create database
    mysql -u root <<MYSQL_SCRIPT
    -- Set root password
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${var.admin_password}';
    
    -- Create application database
    CREATE DATABASE IF NOT EXISTS appdb;
    
    -- Create application user with remote access
    CREATE USER IF NOT EXISTS '${var.admin_username}'@'%' IDENTIFIED BY '${var.admin_password}';
    
    -- Grant privileges
    GRANT ALL PRIVILEGES ON appdb.* TO '${var.admin_username}'@'%';
    FLUSH PRIVILEGES;
    MYSQL_SCRIPT
    
    # Log completion
    echo "MariaDB installation and configuration completed" > /var/log/mariadb-setup.log
    EOF
  )

  tags = {
    Environment = "Capstone"
    Role        = "Database"
    ManagedBy   = "Terraform"
  }
}

