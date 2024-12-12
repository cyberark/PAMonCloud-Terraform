resource "azurerm_virtual_machine" "component_vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.component_network_interface.id]
  vm_size               = var.vm_size
  zones                 = var.availability_zone

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true


  storage_image_reference {
    id = var.image_id
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk-${random_uuid.random_suffix.id}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = var.vm_hostname
    admin_username = var.vm_admin_user
    admin_password = var.vm_admin_password
  }

  # Windows OS configuration:
  dynamic "os_profile_windows_config" {
    for_each = local.component_data[var.component].operating_system == "windows" ? [1] : []
    content {
      provision_vm_agent = true
    }
  }

  dynamic "identity" {
    for_each = local.component_data[var.component].operating_system == "windows" ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  # Linux OS configuration:
  dynamic "os_profile_linux_config" {
    for_each = local.component_data[var.component].operating_system == "linux" ? [1] : []
    content {
      disable_password_authentication = false
    }
  }

  tags = {
    Name = var.vm_name
  }
} 