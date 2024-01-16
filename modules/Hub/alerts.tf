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

module "monitoring-alerts-action-group-critical" {
  source                    = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Action-Groups?ref=v0.5.0"
  montior_action_group_name = join("-", [var.project, "critical", var.environment, var.padding])
  tags                      = local.default_tags
  resource_group_name       = module.hub-resource-group.resource_group_name
  short_name                = "Critical"
  email_receivers           = var.monitoring_alerts_actions_emails_critical
  actions_webhook_critical  = []
  depends_on                = [module.hub-resource-group]
}

module "monitoring-alerts-action-group-warning" {
  source                    = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Action-Groups?ref=v0.5.0"
  montior_action_group_name = join("-", [var.project, "warning", var.environment, var.padding])
  tags                      = local.default_tags
  resource_group_name       = module.hub-resource-group.resource_group_name
  short_name                = "Warning"
  actions_webhook_critical  = []
  email_receivers           = var.monitoring_alerts_actions_emails_warning
  depends_on                = [module.hub-resource-group]
}

## Firewall
module "fw-snat-port-utilization-percent-monitoring-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.5.0"
  tags                = local.default_tags
  resource_group_name = module.hub-resource-group.resource_group_name
  location            = var.location
  metric_alerts = {
    "fw-snat-port-utilization-percent-monitoring-alert-critical" = {
      scopes                    = [module.firewall.firewall_id],
      alert_name                = join("-", [var.project, "CriticalFirewallSnatPortUtilizationLimitExceeded", var.environment, var.location, var.padding])
      description               = "[CRITICAL] Average snat port utilization of firewall has exceeded it's limit which is ${var.firewall_snat_port_utilization_percent_critical_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "Microsoft.Network/azureFirewalls"
      criteria_metric_name      = "SNATPortUtilization"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      criteria_threshold        = var.firewall_snat_port_utilization_percent_critical_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_critical
      target_resource_type      = "Microsoft.Network/azureFirewalls"
      window_size               = "PT5M"
    }
    "fw-snat-port-utilization-percent-monitoring-alert-warning" = {
      scopes                    = [module.firewall.firewall_id],
      alert_name                = join("-", [var.project, "WarningFirewallSnatPortUtilizationLimitExceeded", var.environment, var.location, var.padding])
      description               = "[WARNING] Average snat port utilization of firewall has exceeded it's limit which is ${var.firewall_snat_port_utilization_percent_warning_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "Microsoft.Network/azureFirewalls"
      criteria_metric_name      = "SNATPortUtilization"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      criteria_threshold        = var.firewall_snat_port_utilization_percent_warning_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "Microsoft.Network/azureFirewalls"
      window_size               = "PT5M"
    }
    "fw-health-state-monitoring-alert-critical" = {
      scopes                    = [module.firewall.firewall_id],
      alert_name                = join("-", [var.project, "CriticalFirewallHealthStateReducedBelowLimt", var.environment, var.location, var.padding])
      description               = "[CRITICAL] Average firewall health state has reduced below it's limit which is ${var.firewall_health_state_critical_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "Microsoft.Network/azureFirewalls"
      criteria_metric_name      = "FirewallHealth"
      criteria_aggregation      = "Average"
      criteria_operator         = "LessThanOrEqual"
      criteria_threshold        = var.firewall_health_state_critical_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_critical
      target_resource_type      = "Microsoft.Network/azureFirewalls"
      window_size               = "PT5M"
    }
    "fw-health-state-monitoring-alert-warning" = {
      scopes                    = [module.firewall.firewall_id],
      alert_name                = join("-", [var.project, "WarningFirewallHealthStateReducedBelowLimt", var.environment, var.location, var.padding])
      description               = "[WARNING] Average firewall health state has reduced below it's limit which is ${var.firewall_health_state_warning_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "Microsoft.Network/azureFirewalls"
      criteria_metric_name      = "FirewallHealth"
      criteria_aggregation      = "Average"
      criteria_operator         = "LessThanOrEqual"
      criteria_threshold        = var.firewall_health_state_warning_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "Microsoft.Network/azureFirewalls"
      window_size               = "PT5M"
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.hub-resource-group,
    module.firewall,
    module.monitoring-alerts-action-group-critical,
    module.monitoring-alerts-action-group-warning
  ]
}
