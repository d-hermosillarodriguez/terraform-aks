rg_name = "rg-s2"
rg_location = "eastus2"
rg_group = 8
vnet_name = "my-vnet"
vnet_address_space = ["12.0.0.0/16"]
subnet_name = "internal"
subnet_address_prefixes = ["12.0.0.0/20"]
acr_name = "myACRDiplosc2"
acr_sku = "Basic"
acr_admin_enabled = true
aks_name = "aks-sec2"
aks_dns_prefix = "aks1"
aks_kubernetes_version = "1.24.3"
aks_rbac_enabled = true

aks_np_name = "default"
aks_np_name2 = "adicional"

aks_np_node_count = 1
aks_np_vm_size = "Standard_D2_v2"
aks_np_enabled_auto_scaling = true
aks_np_max_count = 3
aks_np_max_count2 = 80
aks_np_min_count = 1
aks_sp_client_id = "--"
aks_sp_client_secret = "--"
aks_net_plugin = "azure"
aks_net_policy = "azure"