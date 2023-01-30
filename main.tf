resource "azurerm_resource_group" "rg-demo" {
    name = var.rg_name
    location = var.rg_location

    tags = {
      "Grupo" = var.rg_group
    }
}

resource "azurerm_virtual_network" "vnet-demo" {
    name = var.vnet_name
    address_space = var.vnet_address_space
    location = azurerm_resource_group.rg-demo.location
    resource_group_name = azurerm_resource_group.rg-demo.name
}

resource "azurerm_subnet" "subnet-demo" {
    name = var.subnet_name
    resource_group_name = azurerm_resource_group.rg-demo.name
    virtual_network_name = azurerm_virtual_network.vnet-demo.name
    address_prefixes = var.subnet_address_prefixes
}

resource "azurerm_container_registry" "acr-demo" {
    name = var.acr_name
    resource_group_name = azurerm_resource_group.rg-demo.name
    location = azurerm_resource_group.rg-demo.location
    sku = var.acr_sku
    admin_enabled = var.acr_admin_enabled
}

resource "azurerm_kubernetes_cluster" "aks-demo" {
    name = var.aks_name
    location = azurerm_resource_group.rg-demo.location
    resource_group_name = azurerm_resource_group.rg-demo.name
    dns_prefix = var.aks_dns_prefix
    kubernetes_version = var.aks_kubernetes_version
    role_based_access_control_enabled = var.aks_rbac_enabled

    # default_node_pool {
    #   name = var.aks_np_name
    #   node_count = var.aks_np_node_count
    #   vm_size = var.aks_np_vm_size
    #   vnet_subnet_id = azurerm_subnet.subnet-demo.id
    #   enable_auto_scaling = var.aks_np_enabled_auto_scaling
    #   max_count = var.aks_np_max_count
    #   min_count = var.aks_np_min_count
    # }
    default_node_pool {
      name = var.aks_np_name2
      node_count = var.aks_np_node_count
      vm_size = var.aks_np_vm_size
      vnet_subnet_id = azurerm_subnet.subnet-demo.id
      enable_auto_scaling = var.aks_np_enabled_auto_scaling
      max_count = var.aks_np_max_count2
      min_count = var.aks_np_min_count
    }

    service_principal {
      client_id = var.aks_sp_client_id
      client_secret = var.aks_sp_client_secret
    }
  
  network_profile {
    network_plugin = var.aks_net_plugin
    network_policy = var.aks_net_policy
  }
}
#jenkins
resource "azurerm_linux_virtual_machine" "vm-jenkins" {
    name = var.hostname
    resource_group_name = azurerm_resource_group.rg-demo.name
    location = azurerm_resource_group.rg-demo.location
    size = "Standard_B1s"
    network_interface_ids = [azurerm_network_interface.netinter-demo.id]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "16.04-LTS"
      version = "Latest"
    }
    computer_name = var.hostname
    admin_username = var.username
    admin_password = var.passwd
    disable_password_authentication = false
 }
 resource "null_resource" remoteExecProvisionerWFolder {

  provisioner "file" {
    source      = "ansible_docts/inventory.txt"
    destination = "/tmp/inventory.txt"
  }

  provisioner "file" {
    source      = "ansible_docts/playbook.yml"
    destination = "/tmp/playbook.yml"
  }
  connection {
    host     = azurerm_public_ip.pip-demo.ip_address
    type     = "ssh"
    user     = var.username
    password = var.passwd
    agent    = "false"
  }
}
#jenkins ext
resource "azurerm_virtual_machine_extension" "vmext" {
    virtual_machine_id = azurerm_linux_virtual_machine.vm-jenkins.id
    name  = "jenkins-vmext"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    protected_settings = <<PROT
    {
        "script": "${base64encode(file(var.file))}"
    }
    PROT
}