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

output "hub_resource_group_name" {
  value       = module.hub-resource-group.resource_group_name
  description = "The name of the Hub resource group"
  depends_on  = [module.hub-resource-group]
}

output "vnet_resource_id" {
  value       = module.hub-virtual-network.virtual_network_id
  description = "Virtual network resource ID"
  depends_on  = [module.hub-virtual-network]
}

output "hub_virtual_network_name" {
  value       = module.hub-virtual-network.virtual_network_name
  description = "The name of the Virtual Network"
  depends_on  = [module.hub-virtual-network]
}

output "firewall_private_ip" {
  value       = module.firewall.firewall_private_ip
  description = "Private IP of the Firewall"
  depends_on  = [module.firewall]
}

output "firewall_resource_id" {
  value       = module.firewall.firewall_id
  description = "Firewall resource ID"
  depends_on  = [module.firewall]
}

output "la_resource_id" {
  value       = module.log-analytics-workspace.log_analytics_workspace_id
  description = "Log analytics workspace resource ID"
  depends_on  = [module.log-analytics-workspace]
}

output "bastion_admin_group_id" {
  value       = module.bastion-admin-ad-group.group_id
  description = "Bastion Admin Group ID"
  depends_on  = [module.bastion-admin-ad-group]
}

output "bastion_user_group_id" {
  value       = module.bastion-user-ad-group.group_id
  description = "Bastion User Group ID"
  depends_on  = [module.bastion-user-ad-group]
}
