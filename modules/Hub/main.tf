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

# Create resource group
module "hub-resource-group" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Resource-Group?ref=v0.5.0"
  resource_group_name = join("-", [var.project, var.hub_name, var.environment, var.location, var.padding])
  location            = var.location
  tags                = local.default_tags
}

# Create a virtual network within the resource group
module "hub-virtual-network" {
  source                        = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Virtual-Network?ref=v0.5.0"
  virtual_network_name          = join("-", [var.project, var.hub_name, var.environment, var.location, var.padding])
  resource_group_name           = module.hub-resource-group.resource_group_name
  location                      = var.location
  virtual_network_address_space = var.virtual_network_address_space
  tags                          = local.default_tags
  private_dns_zones = [
    {
      name      = "blob",
      zone_name = local.private_dns_zone_name_blob
    },
    {
      name      = "azureautomation"
      zone_name = local.private_dns_zone_name_azure_automation
    },
    {
      name      = "azuremonitor"
      zone_name = local.private_dns_zone_name_azure_monitor
    },
    {
      name      = "azuremonitoroms"
      zone_name = local.private_dns_zone_name_azure_monitor_oms
    },
    {
      name      = "azuremonitorods"
      zone_name = local.private_dns_zone_name_azure_monitor_ods
    },
    {
      name      = "vaultcore",
      zone_name = local.private_dns_zone_name_key_vault
    },
    {
      name      = "file",
      zone_name = local.private_dns_zone_name_fileshare
    }
  ]
  depends_on = [
    module.hub-resource-group,
    module.private-dns-blob,
    module.private-dns-azure-automation,
    module.private-dns-azure-monitor,
    module.private-dns-azure-monitor-oms,
    module.private-dns-azure-monitor-ods,
    module.private-dns-key-vault,
    module.private-dns-fileshare,
  ]
}

# Public IP address Prefix
module "public-ip-prefix" {
  source                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Public-IP-Prefix?ref=v0.5.0"
  public_ip_prefix_name = join("-", [var.project, join("", ["fw", var.hub_name]), var.environment, var.padding])
  location              = var.location
  prefix_length         = var.public_ip_prefix_length
  tags                  = local.default_tags
  resource_group_name   = module.hub-resource-group.resource_group_name
  depends_on            = [module.hub-resource-group]
}

# Create Firewall
module "firewall" {
  source                  = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Firewall?ref=v0.5.0"
  firewall_name           = join("-", [var.project, var.hub_name, var.environment, var.location, var.padding])
  tags                    = local.default_tags
  location                = var.location
  resource_group_name     = module.hub-resource-group.resource_group_name
  virtual_network_name    = module.hub-virtual-network.virtual_network_name
  subnet_address_prefixes = var.firewall_subnet_address_prefix
  zones                   = var.firewall_zones
  public_ip_prefixes      = local.firewall_public_ips
  depends_on = [
    module.hub-resource-group,
    module.hub-virtual-network,
    module.public-ip-prefix
  ]
}

# Firewall Allow Network Rule
module "firewall-allow-network-rule" {
  source                                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Firewall-Network-Rules?ref=v0.5.0"
  firewall_network_rule_collection_name = join("-", [var.shortened_project, var.hub_name, var.firewall_network_rule_collection_name_allow, var.shortened_environment, var.shortened_location, var.shortened_padding])
  firewall_name                         = module.firewall.firewall_name
  resource_group_name                   = module.hub-resource-group.resource_group_name
  action                                = "Allow"
  priority                              = var.firewall_network_rule_collection_priority
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
    "AllowHTTPForDevOps" = {
      name                  = "AllowHTTPForDevOps"
      source_addresses      = var.scale_set_agents_subnet_address_prefixes
      destination_ports     = ["80"]
      destination_addresses = ["*"]
      protocols             = ["TCP"]
    }
    "AllowTimeSync" = {
      name                  = "AllowTimeSync"
      source_addresses      = [var.virtual_network_address_space]
      destination_ports     = ["123"]
      destination_addresses = ["*"]
      protocols             = ["TCP", "UDP"]
    }
  }
  depends_on = [
    module.hub-resource-group,
    module.firewall
  ]
}

# Create Azure Monitor Log Analytics Workspace
module "log-analytics-workspace" {
  source                       = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Log-Analytics-Workspace?ref=v0.5.0"
  log_analytics_workspace_name = join("-", [var.project, var.hub_name, var.environment, var.location, var.padding])
  resource_group_name          = module.hub-resource-group.resource_group_name
  tags                         = local.default_tags
  location                     = var.location
  log_analytics_workspace_sku  = var.log_analytics_workspace_sku
  log_retention_in_days        = var.log_analytics_workspace_log_retention_in_days
  internet_ingestion_enabled   = var.log_analytics_workspace_internet_ingestion_enabled
  internet_query_enabled       = var.log_analytics_workspace_internet_query_enabled
  depends_on = [
    module.hub-resource-group
  ]
}

# Create Azure Monitor Private Link Scope resources
module "monitor-private-link-scope" {
  source                          = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Azure-Monitor-Private-Link-Scope?ref=v0.5.0"
  monitor_private_link_scope_name = join("-", [var.project, var.private_link_scope_workload_name, var.environment, var.location, var.padding])
  resource_group_name             = module.hub-resource-group.resource_group_name
  tags                            = local.default_tags
  depends_on = [
    module.hub-resource-group
  ]
}

# Create Azure Monitor Private Link Scope Service resources
module "monitor-private-link-scope-service" {
  source                                   = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Azure-Monitor-Private-Link-Scope-Service?ref=v0.5.0"
  monitor_private_link_scoped_service_name = join("-", [var.project, var.private_link_scope_workload_name, var.environment, var.location, var.padding])
  resource_group_name                      = module.hub-resource-group.resource_group_name
  private_link_scope_name                  = module.monitor-private-link-scope.monitor_private_link_scope_name
  linked_resource_id                       = module.log-analytics-workspace.log_analytics_workspace_id
  depends_on = [
    module.hub-resource-group,
    module.monitor-private-link-scope,
    module.log-analytics-workspace
  ]
}

module "private-dns-blob" {
  source                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone?ref=v0.5.0"
  tags                  = local.default_tags
  private_dns_zone_name = local.private_dns_zone_name_blob
  resource_group_name   = module.hub-resource-group.resource_group_name
  depends_on            = [module.hub-resource-group]
}

module "private-dns-azure-automation" {
  source                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone?ref=v0.5.0"
  tags                  = local.default_tags
  private_dns_zone_name = local.private_dns_zone_name_azure_automation
  resource_group_name   = module.hub-resource-group.resource_group_name
  depends_on            = [module.hub-resource-group]
}

module "private-dns-azure-monitor" {
  source                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone?ref=v0.5.0"
  tags                  = local.default_tags
  private_dns_zone_name = local.private_dns_zone_name_azure_monitor
  resource_group_name   = module.hub-resource-group.resource_group_name
  depends_on            = [module.hub-resource-group]
}

module "private-dns-azure-monitor-oms" {
  source                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone?ref=v0.5.0"
  tags                  = local.default_tags
  private_dns_zone_name = local.private_dns_zone_name_azure_monitor_oms
  resource_group_name   = module.hub-resource-group.resource_group_name
  depends_on            = [module.hub-resource-group]
}

module "private-dns-azure-monitor-ods" {
  source                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone?ref=v0.5.0"
  tags                  = local.default_tags
  private_dns_zone_name = local.private_dns_zone_name_azure_monitor_ods
  resource_group_name   = module.hub-resource-group.resource_group_name
  depends_on            = [module.hub-resource-group]
}

# Create Private Endpoint Subnet
module "private-endpoint-subnet" {
  source                                   = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-EndPoint-Subnet?ref=v0.5.0"
  network_security_group_name              = join("-", [var.project, var.hub_name, var.environment, var.location, var.padding])
  private_endpoint_subnet_name             = join("-", [var.private_endpoint_subnet_workload_name, var.padding])
  private_endpoint_subnet_route_table_name = join("-", [var.private_endpoint_subnet_workload_name, var.project, var.hub_name, var.environment, var.location, var.padding])
  address_prefixes                         = var.private_endpoint_subnet_address_prefix
  tags                                     = local.default_tags
  location                                 = var.location
  resource_group_name                      = module.hub-resource-group.resource_group_name
  virtual_network_name                     = module.hub-virtual-network.virtual_network_name
  depends_on = [
    module.hub-resource-group,
    module.hub-virtual-network
  ]
}

# Azure monitor private link scope private endpoint
module "monitor-private-link-scope-private-endpoint" {
  source                                   = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-Endpoint?ref=v0.5.0"
  private_endpoint_name                    = join("-", [var.project, var.private_endpoint_subnet_workload_name_ampls, var.environment, var.location, var.padding])
  private_endpoint_service_connection_name = join("-", [var.project, var.private_endpoint_subnet_workload_name_ampls, var.environment, var.location, var.padding])
  private_endpoint_dns_zone_group_name     = join("-", [var.project, var.private_endpoint_subnet_workload_name_ampls, var.environment, var.location, var.padding])
  location                                 = var.location
  private_connection_resource_id           = module.monitor-private-link-scope.monitor_private_link_scope_id
  private_dns_zone_ids = [
    module.private-dns-azure-automation.private_dns_zone_id,
    module.private-dns-azure-monitor.private_dns_zone_id,
    module.private-dns-azure-monitor-oms.private_dns_zone_id,
    module.private-dns-azure-monitor-ods.private_dns_zone_id,
    module.private-dns-blob.private_dns_zone_id
  ]
  resource_group_name        = module.hub-resource-group.resource_group_name
  subresource_names          = ["azuremonitor"]
  tags                       = local.default_tags
  private_endpoint_subnet_id = module.private-endpoint-subnet.private_endpoint_subnet_id
  depends_on = [
    module.monitor-private-link-scope,
    module.private-endpoint-subnet,
    module.hub-resource-group,
    module.private-dns-azure-automation,
    module.private-dns-azure-monitor,
    module.private-dns-azure-monitor-oms,
    module.private-dns-azure-monitor-ods,
    module.private-dns-blob
  ]
}

# Bastion Host
module "bastion-host" {
  source                       = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Bastion-Host?ref=v0.5.0"
  bastion_host_name            = join("-", [var.project, var.hub_name, var.environment, var.location, var.padding])
  network_security_group_name  = join("-", [var.project, var.hub_name, var.environment, var.location, var.padding])
  public_ip_name               = join("-", [var.project, join("", ["bastion", var.hub_name]), var.environment, var.location, var.padding])
  location                     = var.location
  resource_group_name          = module.hub-resource-group.resource_group_name
  file_copy_enabled            = var.bastion_file_copy_enabled
  tunneling_enabled            = var.bastion_tunneling_enabled
  sku                          = var.bastion_host_sku
  virtual_network_name         = module.hub-virtual-network.virtual_network_name
  subnet_address_prefixes      = var.bastion_host_subnet_address_prefix
  allow_https_internet_inbound = var.allow_bastion_https_internet_inbound
  public_address_prefixes      = var.public_address_prefixes
  tags                         = local.default_tags
  depends_on = [
    module.hub-resource-group,
    module.hub-virtual-network
  ]
}

# Bastion Host Admin AD Groups
module "bastion-admin-ad-group" {
  source     = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Group?ref=v0.5.0"
  group_name = join("-", [var.project, var.environment, var.bastion_admin_ad_group_workload_name])
}

# Bastion Host User AD Groups
module "bastion-user-ad-group" {
  source     = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Group?ref=v0.5.0"
  group_name = join("-", [var.project, var.environment, var.bastion_user_ad_group_workload_name])
}

# Bastion Host RBAC for Admin AD Groups
module "bastion-host-rbac-bastion-admin-ad-group-reader" {
  source               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment?ref=v0.5.0"
  principal_id         = module.bastion-admin-ad-group.group_id
  resource_id          = module.bastion-host.bastion_host_id
  role_definition_name = var.role_definition_name_reader
  depends_on = [
    module.bastion-host,
    module.bastion-admin-ad-group
  ]
}

# Bastion Host RBAC for User AD Groups
module "bastion-host-rbac-bastion-user-ad-group-reader" {
  source               = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment?ref=v0.5.0"
  principal_id         = module.bastion-user-ad-group.group_id
  resource_id          = module.bastion-host.bastion_host_id
  role_definition_name = var.role_definition_name_reader
  depends_on = [
    module.bastion-host,
    module.bastion-user-ad-group
  ]
}

## Scale set agents
module "scale-set-agents" {
  source                                                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Azure-DevOps-Custom-Image-Scale-Set-Agents?ref=v0.5.0"
  scale_set_name                                        = join("-", [var.project, join("", [var.devops_scale_set_agents_workload_name, var.hub_name]), var.environment, var.location, var.padding])
  virtual_machine_scale_set_nic_name                    = join("-", [var.project, join("", [var.devops_scale_set_agents_workload_name, var.hub_name]), var.environment, var.location, var.padding])
  subnet_name                                           = join("-", [join("", [var.devops_scale_set_agents_workload_name, var.hub_name]), var.padding])
  virtual_machine_scale_set_network_security_group_name = join("-", [var.project, join("", [var.devops_scale_set_agents_workload_name, var.hub_name]), var.environment, var.location, var.padding])
  admin_ssh_public_key                                  = var.devops_scale_set_agents_admin_ssh_public_key
  admin_username                                        = var.devops_scale_set_agents_admin_username
  location                                              = var.location
  resource_group_name                                   = module.hub-resource-group.resource_group_name
  sku                                                   = var.devops_scale_set_agents_sku
  subnet_address_prefixes                               = var.scale_set_agents_subnet_address_prefixes
  virtual_network_name                                  = module.hub-virtual-network.virtual_network_name
  source_image_id                                       = var.devops_scale_set_agents_source_image_id
  tags                                                  = local.default_tags
  service_endpoints                                     = var.devops_scale_set_agents_subnet_service_endpoints
  depends_on = [
    module.hub-resource-group,
    module.hub-virtual-network
  ]
}

# Route table for vmss and bastion service subnet to firewall
module "scale-set-agents-firewall-egress-route" {
  source                           = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Route-Table-Firewall-Egress?ref=v0.5.0"
  route_table_firewall_egress_name = join("-", [var.project, join("", [var.firewall_egress_route_workload_name, var.hub_name]), var.environment, var.padding])
  firewall_private_ip              = module.firewall.firewall_private_ip
  location                         = var.location
  resource_group_name              = module.hub-resource-group.resource_group_name
  subnet_id                        = module.scale-set-agents.scale_set_agent_subnet_id
  tags                             = local.default_tags
  depends_on = [
    module.hub-resource-group,
    module.firewall,
    module.scale-set-agents
  ]
}

# Create Private DNS Zone for key vaults
module "private-dns-key-vault" {
  source                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone?ref=v0.5.0"
  tags                  = local.default_tags
  private_dns_zone_name = local.private_dns_zone_name_key_vault
  resource_group_name   = module.hub-resource-group.resource_group_name
  depends_on            = [module.hub-resource-group]
}


module "private-dns-fileshare" {
  source                = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone?ref=v0.5.0"
  tags                  = local.default_tags
  private_dns_zone_name = local.private_dns_zone_name_fileshare
  resource_group_name   = module.hub-resource-group.resource_group_name
  depends_on = [
    module.hub-resource-group
  ]
}
