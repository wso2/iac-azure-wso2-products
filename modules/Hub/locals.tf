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
    group       = var.hub_name
  }

  firewall_public_ips = {
    for key, value in var.firewall_public_ips :
    key => {
      public_ip_name         = join("-", [var.project, value.public_ip_name, var.environment, var.location, var.padding])
      private_ip_address     = value.private_ip_address
      fw_ip_association_name = value.fw_ip_association_name
      public_ip_prefix_id    = module.public-ip-prefix.public_ip_prefix_id
    }
  }

  private_dns_zone_name_blob              = "privatelink.blob.core.windows.net"
  private_dns_zone_name_key_vault         = "privatelink.vaultcore.azure.net"
  private_dns_zone_name_fileshare         = "privatelink.file.core.windows.net"
  private_dns_zone_name_azure_automation  = "privatelink.agentsvc.azure-automation.net"
  private_dns_zone_name_azure_monitor     = "privatelink.monitor.azure.com"
  private_dns_zone_name_azure_monitor_oms = "privatelink.oms.opinsights.azure.com"
  private_dns_zone_name_azure_monitor_ods = "privatelink.ods.opinsights.azure.com"
}
