# -------------------------------------------------------------------------------------
#
# Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
#
# This software is the property of WSO2 LLC. and its suppliers, if any.
# Dissemination of any information or reproduction of any material contained
# herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
# You may not alter or remove any copyright or other notice from copies of this content.
#
# --------------------------------------------------------------------------------------

# Configure the Azure Resource Manager Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_subscription_id
  tenant_id       = var.tenant_id
  features {}
}

# Create resource group
module "spoke-resource-group" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Resource-Group?ref=v0.5.0"
  resource_group_name = join("-", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  location            = var.location
  tags                = local.default_tags
}

# Create a virtual network
module "spoke-virtual-network" {
  source                        = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Virtual-Network?ref=v0.5.0"
  virtual_network_name          = join("-", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  resource_group_name           = module.spoke-resource-group.resource_group_name
  location                      = var.location
  virtual_network_address_space = var.virtual_network_address_space
  tags                          = local.default_tags
  depends_on = [
    module.spoke-resource-group
  ]
}

# VNet link for the Private DNS Zone for Key Vault .
module "private-dns-zone-vnet-link-key-vault" {
  providers = {
    azurerm = azurerm.hub
  }
  source                          = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.5.0"
  private_dns_zone_vnet_link_name = join("-", [var.project, "vaultcore", var.spoke_name, var.environment, var.padding])
  resource_group_name             = local.hub_resource_group_name
  private_dns_zone_name           = local.private_dns_zone_name_key_vault
  virtual_network_id              = module.spoke-virtual-network.virtual_network_id
  depends_on = [
    module.spoke-virtual-network
  ]
}

# VNet link for the Private DNS Zone for FileShare.
module "private-dns-zone-vnet-link-fileshare" {
  providers = {
    azurerm = azurerm.hub
  }
  source                          = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.5.0"
  private_dns_zone_vnet_link_name = join("-", [var.project, "file", var.spoke_name, var.environment, var.padding])
  resource_group_name             = local.hub_resource_group_name
  private_dns_zone_name           = local.private_dns_zone_name_fileshare
  virtual_network_id              = module.spoke-virtual-network.virtual_network_id
  depends_on = [
    module.spoke-virtual-network
  ]
}

# VNet link for the Private DNS Zone for Azure Monitor ODS.
module "private-dns-zone-vnet-link-azure-monitor-ods" {
  providers = {
    azurerm = azurerm.hub
  }
  source                          = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.5.0"
  private_dns_zone_vnet_link_name = join("-", [var.project, "azuremonitorods", var.spoke_name, var.environment, var.padding])
  resource_group_name             = local.hub_resource_group_name
  private_dns_zone_name           = local.private_dns_zone_name_azure_monitor_ods
  virtual_network_id              = module.spoke-virtual-network.virtual_network_id
  depends_on = [
    module.spoke-virtual-network
  ]
}

# VNet link for the Private DNS Zone for Azure Monitor OMS.
module "private-dns-zone-vnet-link-azure-monitor-oms" {
  providers = {
    azurerm = azurerm.hub
  }
  source                          = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.5.0"
  private_dns_zone_vnet_link_name = join("-", [var.project, "azuremonitoroms", var.spoke_name, var.environment, var.padding])
  resource_group_name             = local.hub_resource_group_name
  private_dns_zone_name           = local.private_dns_zone_name_azure_monitor_oms
  virtual_network_id              = module.spoke-virtual-network.virtual_network_id
  depends_on = [
    module.spoke-virtual-network
  ]
}

# VNet link for the Private DNS Zone for Azure Monitor.
module "private-dns-zone-vnet-link-azure-monitor" {
  providers = {
    azurerm = azurerm.hub
  }
  source                          = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.5.0"
  private_dns_zone_vnet_link_name = join("-", [var.project, "azuremonitor", var.spoke_name, var.environment, var.padding])
  resource_group_name             = local.hub_resource_group_name
  private_dns_zone_name           = local.private_dns_zone_name_azure_monitor
  virtual_network_id              = module.spoke-virtual-network.virtual_network_id
  depends_on = [
    module.spoke-virtual-network
  ]
}

# VNet link for the Private DNS Zone for Azure Automation.
module "private-dns-zone-vnet-link-azure-automation" {
  providers = {
    azurerm = azurerm.hub
  }
  source                          = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone-Vnet-Link?ref=v0.5.0"
  private_dns_zone_vnet_link_name = join("-", [var.project, "azureautomation", var.spoke_name, var.environment, var.padding])
  resource_group_name             = local.hub_resource_group_name
  private_dns_zone_name           = local.private_dns_zone_name_azure_automation
  virtual_network_id              = module.spoke-virtual-network.virtual_network_id
  depends_on = [
    module.spoke-virtual-network
  ]
}

# Hub to Spoke Vnet Peering
module "hub-to-spoke-vnet-peering" {
  providers = {
    azurerm = azurerm.hub
  }
  source                           = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Vnet-Peering?ref=v0.5.0"
  vnet_src_id                      = local.hub_virtual_network_id
  allow_virtual_src_network_access = var.vnet_peering_allow_virtual_src_network_access
  allow_forwarded_src_traffic      = var.vnet_peering_allow_forwarded_src_traffic
  allow_gateway_src_transit        = var.vnet_peering_allow_gateway_src_transit
  use_remote_src_gateway           = var.vnet_peering_use_remote_src_gateway
  vnet_dest_id                     = module.spoke-virtual-network.virtual_network_id
  depends_on = [
    module.spoke-virtual-network
  ]
}

# Spoke to Hub Vnet Peering
module "spoke-to-hub-vnet-peering" {
  source                           = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Vnet-Peering?ref=v0.5.0"
  vnet_src_id                      = module.spoke-virtual-network.virtual_network_id
  allow_virtual_src_network_access = var.vnet_peering_allow_virtual_dest_network_access
  allow_forwarded_src_traffic      = var.vnet_peering_allow_forwarded_dest_traffic
  allow_gateway_src_transit        = var.vnet_peering_allow_gateway_dest_transit
  use_remote_src_gateway           = var.vnet_peering_use_remote_dest_gateway
  vnet_dest_id                     = local.hub_virtual_network_id
  depends_on = [
    module.spoke-virtual-network
  ]
}

# Firewall Alow Network Rule
module "firewall-allow-network-rule" {
  providers = {
    azurerm = azurerm.hub
  }
  source                                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Firewall-Network-Rules?ref=v0.5.0"
  firewall_network_rule_collection_name = join("-", [var.shortened_project, var.spoke_name, var.firewall_network_rule_collection_name_allow, var.shortened_environment, var.shortened_location, var.shortened_padding])
  firewall_name                         = local.hub_firewall_name
  resource_group_name                   = local.hub_resource_group_name
  action                                = "Allow"
  priority                              = var.firewall_network_rule_collection_priority_allow
  depends_on = [
    module.spoke-virtual-network
  ]
  network_rules = {
    "AllowTCP" = {
      name                  = "AllowTCP"
      source_addresses      = [var.virtual_network_address_space]
      destination_ports     = ["443"]
      destination_addresses = ["*"]
      protocols             = ["TCP"]
    }
    "AllowDNS" = {
      name                  = "AllowDNS"
      source_addresses      = [var.virtual_network_address_space]
      destination_ports     = ["53"]
      destination_addresses = ["*"]
      protocols             = ["TCP", "UDP"]
    }
    "AllowSMTP" = {
      name                  = "AllowSMTP"
      source_addresses      = [var.virtual_network_address_space]
      destination_ports     = ["587"]
      destination_addresses = ["*"]
      protocols             = ["TCP", "UDP"]
    }
    "AllowTimeSync" = {
      name                  = "AllowTimeSync"
      source_addresses      = [var.virtual_network_address_space]
      destination_ports     = ["123"]
      destination_addresses = ["*"]
      protocols             = ["TCP", "UDP"]
    }
  }
}

# Firewall Allow DNAT Rule
module "firewall-allow-dnat-rule" {
  providers = {
    azurerm = azurerm.hub
  }
  source                            = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Firewall-LB-DNAT-Rule-Collection?ref=v0.5.0"
  firewall_nat_rule_collection_name = join("-", [var.shortened_project, var.spoke_name, var.firewall_nat_rule_collection_name_allow, var.shortened_environment, var.shortened_location, var.shortened_padding])
  firewall_name                     = local.hub_firewall_name
  resource_group_name               = local.hub_resource_group_name
  priority                          = var.firewall_nat_rule_collection_priority
  dynamic_nat_rules                 = local.firewall_dynamic_dnat_rules
  depends_on = [
    module.spoke-virtual-network
  ]
}

# Firewall Alow Application Rule
module "firewall-allow-application-rule" {
  providers = {
    azurerm = azurerm.hub
  }
  source                                    = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Firewall-Application-Rules?ref=v0.5.0"
  firewall_application_rule_collection_name = join("-", [var.shortened_project, var.spoke_name, var.firewall_application_rule_collection_name_allow, var.shortened_environment, var.shortened_location, var.shortened_padding])
  firewall_name                             = local.hub_firewall_name
  resource_group_name                       = local.hub_resource_group_name
  action                                    = "Allow"
  priority                                  = var.firewall_application_rule_collection_priority_allow
  depends_on = [
    module.spoke-virtual-network
  ]
  application_rules = {
    "AllowSpringbootSchema" = {
      name             = "AllowSpringbootSchema"
      source_addresses = [var.virtual_network_address_space]
      target_fqdns     = ["www.springframework.org"]
      protocol = {
        port = "80"
        type = "Http"
      }
    }
    "AllowNodeKernelUpdates" = {
      name             = "AllowNodeKernelUpdates"
      source_addresses = [var.vmss_workload_subnet_address_prefix]
      target_fqdns     = ["azure.archive.ubuntu.com", "security.ubuntu.com"]
      protocol = {
        port = "80"
        type = "Http"
      }
    }
  }
}

# Create Private Endpoint Subnet
module "private-endpoint-subnet" {
  source                                   = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-EndPoint-Subnet?ref=v0.5.0"
  network_security_group_name              = join("-", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  private_endpoint_subnet_name             = join("-", [var.private_endpoint_subnet_workload_name, var.padding])
  private_endpoint_subnet_route_table_name = join("-", [var.private_endpoint_subnet_workload_name, var.project, var.spoke_name, var.environment, var.location, var.padding])
  address_prefixes                         = var.private_endpoint_subnet_address_prefix
  tags                                     = local.default_tags
  location                                 = var.location
  resource_group_name                      = module.spoke-resource-group.resource_group_name
  virtual_network_name                     = module.spoke-virtual-network.virtual_network_name
  depends_on = [
    module.spoke-resource-group,
    module.spoke-virtual-network
  ]
}

##############################
# Bastion
module "bastion" {
  source                                                        = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Bastion-Internal?ref=v0.5.0"
  managed_disk_name                                             = join("", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  vm_name                                                       = join("", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  computer_name                                                 = join("", [var.project, var.spoke_name, var.environment, var.padding])
  os_disk_name                                                  = join("", [var.project, var.spoke_name, var.location, var.padding])
  subnet_name                                                   = join("-", [var.padding])
  route_table_name                                              = join("-", ["bastion", var.project, var.spoke_name, var.environment, var.location, var.padding])
  network_security_group_name                                   = join("-", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  nic_name                                                      = join("-", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  ip_configuration_name                                         = join("-", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  application_security_group_name                               = join("-", [var.project, var.spoke_name, var.environment, var.location, var.padding])
  storage_account_name                                          = join("", [var.shortened_project, var.spoke_name, var.shortened_environment, var.shortened_location, var.shortened_padding])
  storage_account_private_endpoint_name                         = join("-", [var.project, var.bastion_storage_account_workload_name, var.environment, var.location, var.padding])
  storage_account_private_endpoint_service_connection_name      = join("-", [var.project, var.bastion_storage_account_workload_name, var.environment, var.location, var.padding])
  private_dns_zone_group_name                                   = join("-", [var.project, var.bastion_storage_account_workload_name, var.environment, var.location, var.padding])
  source_image_id                                               = var.bastion_source_image_id
  admin_username                                                = var.bastion_admin_username
  tags                                                          = local.default_tags
  location                                                      = var.location
  managed_disk_size_gb                                          = var.bastion_managed_disk_size_gb
  os_disk_size_gb                                               = var.bastion_os_disk_size_gb
  public_key_path                                               = var.bastion_public_key_path
  resource_group_name                                           = module.spoke-resource-group.resource_group_name
  size                                                          = var.bastion_size
  subnet_address_prefix                                         = var.bastion_vm_subnet_address_prefix
  virtual_network_name                                          = module.spoke-virtual-network.virtual_network_name
  firewall_private_ip                                           = var.firewall_private_ip
  private_endpoint_subnet_id                                    = module.private-endpoint-subnet.private_endpoint_subnet_id
  private_dns_zone_ids                                          = [local.private_dns_zone_id_blob]
  storage_account_network_rules_ip_rules                        = [
    var.wso2_us_vpn_outbound_ip,
    var.wso2_lk_office_outbound_ip
  ]
  bastion_subnet_enforce_private_link_endpoint_network_policies = var.bastion_subnet_enforce_private_link_endpoint_network_policies
  depends_on = [
    module.spoke-resource-group,
    module.spoke-virtual-network,
    module.private-endpoint-subnet,
    module.firewall-allow-application-rule,
    module.firewall-allow-dnat-rule,
    module.firewall-allow-network-rule
  ]
}

module "bastion-admin-ad-group-rbac" {
  source               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment?ref=v0.5.0"
  principal_id         = var.bastion_admin_group_id
  resource_id          = module.bastion.bastion_vm_id
  role_definition_name = local.role_definition_name_vm_admin_login
  depends_on = [
    module.bastion
  ]
}

module "bastion-nic-rbac-bastion-admin-ad-group-reader" {
  source               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment?ref=v0.5.0"
  principal_id         = var.bastion_admin_group_id
  resource_id          = module.bastion.network_interface_id
  role_definition_name = local.role_definition_name_reader
  depends_on = [
    module.bastion
  ]
}

module "bastion-user-ad-group-rbac" {
  source               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment?ref=v0.5.0"
  principal_id         = var.bastion_user_group_id
  resource_id          = module.bastion.bastion_vm_id
  role_definition_name = local.role_definition_name_vm_user_login
  depends_on = [
    module.bastion
  ]
}

module "bastion-nic-rbac-bastion-user-ad-group-reader" {
  source               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment?ref=v0.5.0"
  principal_id         = var.bastion_user_group_id
  resource_id          = module.bastion.network_interface_id
  role_definition_name = local.role_definition_name_reader
  depends_on = [
    module.bastion
  ]
}

# Create Admin key vault
module "admin-key-vault" {
  source                     = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Key-Vault?ref=v0.5.0"
  key_vault_name             = join("-", [var.shortened_project, var.admin_key_vault_application_name, var.shortened_environment, var.shortened_location, var.shortened_padding])
  tags                       = local.default_tags
  location                   = var.location
  resource_group_name        = module.spoke-resource-group.resource_group_name
  sku_name                   = var.admin_key_vault_sku_name
  vault_access_tenant_id     = var.tenant_id
  soft_delete_retention_days = var.admin_key_vault_soft_delete_retention_days
  network_acls_ip_rules = [
    var.wso2_us_vpn_outbound_ip,
    var.wso2_lk_office_outbound_ip
  ]
  network_acls_default_action = "Deny"
  network_acl_vnet_subnet_ids = []
  depends_on = [
    module.spoke-resource-group
  ]
}

module "admin-key-vault-private-endpoint" {
  source                                   = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-Endpoint?ref=v0.5.0"
  private_endpoint_name                    = join("-", [var.project, var.private_endpoint_subnet_workload_name_admin_key_vault, var.environment, var.location, var.padding])
  private_endpoint_service_connection_name = join("-", [var.project, var.private_endpoint_subnet_workload_name_admin_key_vault, var.environment, var.location, var.padding])
  private_endpoint_dns_zone_group_name     = join("-", [var.project, var.private_endpoint_subnet_workload_name_admin_key_vault, var.environment, var.location, var.padding])
  location                                 = var.location
  private_connection_resource_id           = module.admin-key-vault.vault_id
  private_dns_zone_ids                     = [local.private_dns_zone_id_key_vault]
  resource_group_name                      = module.spoke-resource-group.resource_group_name
  subresource_names                        = ["vault"]
  tags                                     = local.default_tags
  private_endpoint_subnet_id               = module.private-endpoint-subnet.private_endpoint_subnet_id
  depends_on = [
    module.private-endpoint-subnet,
    module.spoke-resource-group,
    module.admin-key-vault,
    module.private-dns-zone-vnet-link-key-vault
  ]
}

# Create development key vault
module "deve-key-vault" {
  source                     = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Key-Vault?ref=v0.5.0"
  key_vault_name             = join("-", [var.shortened_project, var.development_key_vault_application_name, var.shortened_environment, var.shortened_location, var.shortened_padding])
  tags                       = local.default_tags
  location                   = var.location
  resource_group_name        = module.spoke-resource-group.resource_group_name
  sku_name                   = var.development_key_vault_sku_name
  vault_access_tenant_id     = var.tenant_id
  soft_delete_retention_days = var.development_key_vault_soft_delete_retention_days
  network_acls_ip_rules = [
    var.wso2_us_vpn_outbound_ip,
    var.wso2_lk_office_outbound_ip
  ]
  network_acls_default_action = "Deny"
  network_acl_vnet_subnet_ids = []
  depends_on = [
    module.spoke-resource-group
  ]
}

module "deve-key-vault-private-endpoint" {
  source                                   = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-Endpoint?ref=v0.5.0"
  private_endpoint_name                    = join("-", [var.project, var.private_endpoint_subnet_workload_name_development_key_vault, var.environment, var.location, var.padding])
  private_endpoint_service_connection_name = join("-", [var.project, var.private_endpoint_subnet_workload_name_development_key_vault, var.environment, var.location, var.padding])
  private_endpoint_dns_zone_group_name     = join("-", [var.project, var.private_endpoint_subnet_workload_name_development_key_vault, var.environment, var.location, var.padding])
  location                                 = var.location
  private_connection_resource_id           = module.deve-key-vault.vault_id
  private_dns_zone_ids                     = [local.private_dns_zone_id_key_vault]
  resource_group_name                      = module.spoke-resource-group.resource_group_name
  subresource_names                        = ["vault"]
  tags                                     = local.default_tags
  private_endpoint_subnet_id               = module.private-endpoint-subnet.private_endpoint_subnet_id
  depends_on = [
    module.private-endpoint-subnet,
    module.spoke-resource-group,
    module.deve-key-vault,
    module.private-dns-zone-vnet-link-key-vault
  ]
}

# Create DevOPS SP for admin deve key vault
module "admin-deve-key-vault-dev-ops-ad-application" {
  source           = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Application?ref=v0.5.0"
  application_name = join("-", [var.project, var.environment, var.admin_deve_kv_dev_ops_ad_application_name])
}

module "admin-deve-key-vault-dev-ops-ad-sp" {
  source            = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Service-Principal?ref=v0.5.0"
  ad_application_id = module.admin-deve-key-vault-dev-ops-ad-application.application_id
  depends_on = [
    module.admin-deve-key-vault-dev-ops-ad-application
  ]
}

module "admin-key-vault-dev-ops-ad-sp-rbac" {
  source               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment?ref=v0.5.0"
  principal_id         = module.admin-deve-key-vault-dev-ops-ad-sp.sp_internal_id
  resource_id          = module.admin-key-vault.vault_id
  role_definition_name = local.role_definition_name_reader
  depends_on = [
    module.admin-deve-key-vault-dev-ops-ad-sp,
    module.admin-key-vault
  ]
}

module "deve-key-vault-dev-ops-ad-sp-rbac" {
  source               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment?ref=v0.5.0"
  principal_id         = module.admin-deve-key-vault-dev-ops-ad-sp.sp_internal_id
  resource_id          = module.deve-key-vault.vault_id
  role_definition_name = local.role_definition_name_reader
  depends_on = [
    module.admin-deve-key-vault-dev-ops-ad-sp,
    module.deve-key-vault
  ]
}

module "admin-deve-key-vault-dev-ops-sp-password" {
  source         = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Service-Principal-Password?ref=v0.5.0"
  sp_internal_id = module.admin-deve-key-vault-dev-ops-ad-sp.sp_internal_id
  depends_on = [
    module.admin-deve-key-vault-dev-ops-ad-sp
  ]
}

# create access policies for key vaults
module "admin-key-vault-dev-ops-ad-sp-access-policy" {
  source                               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Key-Vault-Access-Policy?ref=v0.5.0"
  vault_access_object_id               = module.admin-deve-key-vault-dev-ops-ad-sp.sp_object_id
  vault_access_tenant_id               = var.tenant_id
  key_vault_id                         = module.admin-key-vault.vault_id
  vault_access_key_permissions         = var.key_vault_dev_ops_ad_sp_access_key_permissions
  vault_access_secret_permissions      = var.key_vault_dev_ops_ad_sp_access_secret_permissions
  vault_access_certificate_permissions = var.key_vault_dev_ops_ad_sp_access_certificate_permissions
  depends_on = [
    module.admin-key-vault,
    module.admin-deve-key-vault-dev-ops-ad-sp
  ]
}

# create access policies for key vaults
module "deve-key-vault-dev-ops-ad-sp-access-policy" {
  source                               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Key-Vault-Access-Policy?ref=v0.5.0"
  vault_access_object_id               = module.admin-deve-key-vault-dev-ops-ad-sp.sp_object_id
  vault_access_tenant_id               = var.tenant_id
  key_vault_id                         = module.deve-key-vault.vault_id
  vault_access_key_permissions         = var.key_vault_dev_ops_ad_sp_access_key_permissions
  vault_access_secret_permissions      = var.key_vault_dev_ops_ad_sp_access_secret_permissions
  vault_access_certificate_permissions = var.key_vault_dev_ops_ad_sp_access_certificate_permissions
  depends_on = [
    module.deve-key-vault,
    module.admin-deve-key-vault-dev-ops-ad-sp
  ]
}

# Create cluster product SP for Deve key vault
module "deve-key-vault-cluster-product-ad-application" {
  source           = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Application?ref=v0.5.0"
  application_name = join("-", [var.project, var.environment, var.key_vault_cluster_product_ad_application_name])
}

module "deve-key-vault-cluster-product-ad-sp" {
  source            = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Service-Principal?ref=v0.5.0"
  ad_application_id = module.deve-key-vault-cluster-product-ad-application.application_id
  depends_on = [
    module.deve-key-vault-cluster-product-ad-application
  ]
}

module "deve-key-vault-cluster-product-ad-sp-password" {
  source         = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Service-Principal-Password?ref=v0.5.0"
  sp_internal_id = module.deve-key-vault-cluster-product-ad-sp.sp_internal_id
  depends_on = [
    module.deve-key-vault-cluster-product-ad-sp
  ]
}

module "deve-key-vault-cluster-product-ad-sp-access-policy" {
  source                               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Key-Vault-Access-Policy?ref=v0.5.0"
  vault_access_object_id               = module.deve-key-vault-cluster-product-ad-sp.sp_object_id
  vault_access_tenant_id               = var.tenant_id
  key_vault_id                         = module.deve-key-vault.vault_id
  vault_access_key_permissions         = var.key_vault_cluster_product_ad_sp_access_key_permissions
  vault_access_secret_permissions      = var.key_vault_cluster_product_ad_sp_access_secret_permissions
  vault_access_certificate_permissions = var.key_vault_cluster_product_ad_sp_access_certificate_permissions
  depends_on = [
    module.deve-key-vault,
    module.deve-key-vault-cluster-product-ad-sp
  ]
}

## Create Azure Recovery Service Vault
module "recovery-services-vault" {
  source                       = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Recovery-Services-Vault?ref=v0.5.0"
  recovery_services_vault_name = join("-", [var.project, var.environment, var.location, var.padding])
  tags                         = local.default_tags
  location                     = var.location
  resource_group_name          = module.spoke-resource-group.resource_group_name
  depends_on = [
    module.spoke-resource-group
  ]
}

## Azure Storage File Share Storage account
module "premium-fileshare-storage-account" {
  source                                                   = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Storage-Account-File?ref=v0.5.0"
  storage_account_name                                     = join("", [var.shortened_project, var.fileshare_storage_application_name, var.shortened_environment, var.shortened_location, var.shortened_padding])
  backup_policy_file_share_name                            = join("", [var.shortened_project, var.fileshare_storage_application_name, var.shortened_environment, var.shortened_location, var.shortened_padding])
  account_replication_type                                 = var.fileshare_storage_account_replication_type
  account_tier                                             = var.fileshare_storage_account_tier
  tags                                                     = local.default_tags
  location                                                 = var.location
  resource_group_name                                      = module.spoke-resource-group.resource_group_name
  recovery_vault_name                                      = module.recovery-services-vault.recovery_vault_name
  storage_account_network_rules_default_action             = "Deny"
  storage_account_network_rules_bypass                     = ["AzureServices", "Metrics", "Logging"]
  storage_account_network_rules_ip_rules                   = [
    var.wso2_us_vpn_outbound_ip,
    var.wso2_lk_office_outbound_ip
  ]
  storage_account_network_rules_virtual_network_subnet_ids = []
  advanced_threat_protection_enabled                       = var.advanced_threat_protection_enabled
  depends_on = [
    module.spoke-resource-group,
    module.recovery-services-vault
  ]
}

module "premium-fileshare-storage-account-private-endpoint" {
  source                                   = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-Endpoint?ref=v0.5.0"
  private_endpoint_name                    = join("-", [var.project, var.private_endpoint_subnet_workload_name_fileshare, var.environment, var.location, var.padding])
  private_endpoint_service_connection_name = join("-", [var.project, var.private_endpoint_subnet_workload_name_fileshare, var.environment, var.location, var.padding])
  private_endpoint_dns_zone_group_name     = join("-", [var.project, var.private_endpoint_subnet_workload_name_fileshare, var.environment, var.location, var.padding])
  location                                 = var.location
  private_connection_resource_id           = module.premium-fileshare-storage-account.storage_account_id
  private_dns_zone_ids                     = [local.private_dns_zone_id_fileshare]
  resource_group_name                      = module.spoke-resource-group.resource_group_name
  subresource_names                        = ["file"]
  tags                                     = local.default_tags
  private_endpoint_subnet_id               = module.private-endpoint-subnet.private_endpoint_subnet_id
  depends_on = [
    module.private-endpoint-subnet,
    module.spoke-resource-group,
    module.premium-fileshare-storage-account,
    module.private-dns-zone-vnet-link-fileshare
  ]
}

### IS File Share
module "premium-fileshare-is-share" {
  source                              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/File-Share?ref=v0.5.0"
  scope                               = var.is_fileshare_name
  file_share_quote                    = var.is_fileshare_quote
  storage_account_name                = module.premium-fileshare-storage-account.storage_account_name
  backup_container_storage_account_id = module.premium-fileshare-storage-account.storage_account_id
  backup_policy_file_share_id         = module.premium-fileshare-storage-account.backup_policy_file_share_id
  recovery_services_vault_name        = module.recovery-services-vault.recovery_vault_name
  resource_group_name                 = module.spoke-resource-group.resource_group_name
  depends_on = [
    module.premium-fileshare-storage-account,
    module.recovery-services-vault,
    module.spoke-resource-group
  ]
}

module "dns-zone" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/DNS-Zone?ref=v0.5.0"
  dns_zone_name       = var.dns_zone_name
  resource_group_name = module.spoke-resource-group.resource_group_name
  depends_on = [
    module.spoke-resource-group
  ]
}

module "dns-zone-a-record" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/DNS-A-Record?ref=v0.5.0"
  record_name         = var.dns_record_name
  dns_zone_name       = var.dns_zone_name
  resource_group_name = module.spoke-resource-group.resource_group_name
  ttl                 = var.dns_ttl
  records             = var.dns_records
  tags                = local.default_tags
  depends_on = [
    module.spoke-resource-group,
    module.dns-zone
  ]
}
