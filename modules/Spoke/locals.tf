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

locals {
  default_tags = {
    project     = var.project
    environment = var.environment
    terraform   = "true"
    group       = var.spoke_name
  }

  hub_resource_group_name  = "rg-${var.project}-${var.hub_name}-${var.hub_environment}-${var.location}-${var.padding}"
  hub_virtual_network_name = "vnet-${var.project}-${var.hub_name}-${var.hub_environment}-${var.location}-${var.padding}"
  hub_virtual_network_id   = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${local.hub_resource_group_name}/providers/Microsoft.Network/virtualNetworks/${local.hub_virtual_network_name}"
  hub_firewall_name        = "fw-${var.project}-${var.hub_name}-${var.hub_environment}-${var.location}-${var.padding}"

  log_analytics_workspace_name = "log-${var.project}-${var.hub_name}-${var.hub_environment}-${var.location}-${var.padding}"
  log_analytics_workspace_id   = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${local.hub_resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/${local.log_analytics_workspace_name}"

  devops_cd_project_is_deploy_build_yml_path = "cd-pipelines/identity-server/${var.spoke_name}-deploy-${var.padding}.yaml"
  devops_cd_project_common_build_yml_path    = "cd-pipelines/common/${var.spoke_name}-setup.yaml"

  private_dns_zone_name_blob              = "privatelink.blob.core.windows.net"
  private_dns_zone_name_key_vault         = "privatelink.vaultcore.azure.net"
  private_dns_zone_name_fileshare         = "privatelink.file.core.windows.net"
  private_dns_zone_name_azure_automation  = "privatelink.agentsvc.azure-automation.net"
  private_dns_zone_name_azure_monitor     = "privatelink.monitor.azure.com"
  private_dns_zone_name_azure_monitor_oms = "privatelink.oms.opinsights.azure.com"
  private_dns_zone_name_azure_monitor_ods = "privatelink.ods.opinsights.azure.com"

  private_dns_zone_id_blob      = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${local.hub_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${local.private_dns_zone_name_blob}"
  private_dns_zone_id_fileshare = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${local.hub_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${local.private_dns_zone_name_fileshare}"
  private_dns_zone_id_key_vault = "/subscriptions/${var.hub_subscription_id}/resourceGroups/${local.hub_resource_group_name}/providers/Microsoft.Network/privateDnsZones/${local.private_dns_zone_name_key_vault}"

  role_definition_name_reader         = "Reader"
  role_definition_name_vm_admin_login = "Virtual Machine Administrator Login"
  role_definition_name_vm_user_login  = "Virtual Machine User Login"

  firewall_dynamic_dnat_rules = {
    for key, value in var.firewall_dynamic_dnat_rules :
    key => {
      private_ip_address     = var.firewall_dynamic_dnat_rules_lb_private_ip_address
      nat_rule_name_shortned = "lb"
      public_ip_address      = value.public_ip_address
    }
  }
}
