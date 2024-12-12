resource "azurerm_virtual_machine" "vault_dr_vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vault_dr_network_interface.id]
  vm_size               = var.vm_size
  zones                 = var.availability_zone

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  identity {
    type = "SystemAssigned"
  }

  storage_image_reference {
    id = var.image_id
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk-${random_uuid.random_suffix.id}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_data_disk {
    name              = "${var.vm_name}-datadisk-${random_uuid.random_suffix.id}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    lun               = 0
    disk_size_gb      = 30
  }

  os_profile {
    computer_name  = var.vm_hostname
    admin_username = var.vm_admin_user
    admin_password = var.vm_admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = {
    Name = var.vm_name
  }
} 