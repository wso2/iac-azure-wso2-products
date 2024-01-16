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
  resource_group_name       = module.spoke-resource-group.resource_group_name
  short_name                = "Critical"
  email_receivers           = var.monitoring_alerts_actions_emails_critical
  actions_webhook_critical  = []
  depends_on                = [module.spoke-resource-group]
}

module "monitoring-alerts-action-group-warning" {
  source                    = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Action-Groups?ref=v0.5.0"
  montior_action_group_name = join("-", [var.project, "warning", var.environment, var.padding])
  tags                      = local.default_tags
  resource_group_name       = module.spoke-resource-group.resource_group_name
  short_name                = "Warning"
  actions_webhook_critical  = []
  email_receivers           = var.monitoring_alerts_actions_emails_warning
  depends_on                = [module.spoke-resource-group]
}


## Service health and resource health
module "health-monitoring-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Log-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  environment         = var.environment
  project             = var.project
  padding             = var.padding

  recommendation_alerts = {}

  resource_health_alerts = {
    "resource_health_critical_component_alert_p1" = {
      scopes = [
        module.premium-fileshare-storage-account.storage_account_id,
       module.spoke-virtual-network.virtual_network_id,
        module.deve-key-vault.vault_id
      ]
      description             = "Monitoring Resource Health alerts of level Critical"
      criteriaLevel           = "Critical"
      criteriaCategory        = "ResourceHealth"
      criteriaReason          = ["PlatformInitiated"]
      currentStatuses         = ["Unavailable"]
      previousStatuses        = ["Available", "Unknown"]
      monitor_action_group_id = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      status                  = "Active"
      reason                  = "[p1]resourcehealthcriticalcomponents"
      query_enabled           = true
      target_resource_id      = null
      target_resource_type    = null
      target_resource_group   = null
    },
    "resource_health_critical_component_alert_p3" = {
      scopes = [
        module.bastion.bastion_vm_id,
        module.premium-fileshare-storage-account.storage_account_id,
      ]
      description             = "Monitoring Resource Health alerts of level Critical"
      criteriaLevel           = "Critical"
      criteriaCategory        = "ResourceHealth"
      criteriaReason          = ["PlatformInitiated"]
      currentStatuses         = ["Degraded"]
      previousStatuses        = ["Available", "Unknown"]
      monitor_action_group_id = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      status                  = "Active"
      reason                  = "[p3]resourcehealthcriticalcomponents"
      query_enabled           = true
      target_resource_id      = null
      target_resource_type    = null
      target_resource_group   = null
    },
    "resource_health_non_critical_component_alert_p3" = {
      scopes = [
        module.bastion.bastion_vm_id,
      ]
      description             = "Monitoring Resource Health alerts of level P3"
      criteriaLevel           = "Critical"
      criteriaCategory        = "ResourceHealth"
      criteriaReason          = ["PlatformInitiated"]
      currentStatuses         = ["Unavailable", "Degraded"]
      previousStatuses        = ["Available", "Unknown"]
      monitor_action_group_id = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      reason                  = "[p3]resourcehealthcriticalnoncomponents"
      status                  = "Active"
      query_enabled           = true
      target_resource_id      = null
      target_resource_type    = null
      target_resource_group   = null
    }
  }

  service_health_alerts = {}

  activity_log_alerts = {}

  specific_service_health_alerts = {
    "service_health_alert_p1" = {
      scopes                  = [join("/", ["/subscriptions", var.subscription_id])]
      description             = "Monitoring Service Health alerts of level P1"
      criteriaLevel           = "Critical"
      query_enabled           = true
      criteriaCategory        = "ServiceHealth"
      monitor_action_group_id = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      reason                  = "[p1]servicehealthcritical"
      targetLocations         = var.service_health_error_alert_target_locations
      targetEvents            = var.service_health_error_alert_target_events
      targetServices = [
        "Activity Logs & Alerts",
        "Alerts",
        "Alerts & Metrics",
        "Azure Active Directory",
        "Key Vault",
        "Storage",
        "Virtual Machines",
        "Virtual Network",
        "Azure DNS",
        "Azure Monitor",
        "Azure Private Link",
        "Network Infrastructure",
      ]
    }
  }
}
## Key vault

module "admin-key_vault-availability-p3-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "admin_key_vault_p3_alerts" = {
      scopes                    = [module.admin-key-vault.vault_id]
      reason                    = "P3-AdminKeyVaultAvailabilityDecreased"
      description               = "[P3] Average availability of the Admin Key vault has dropped to ${var.keyvault_availability_critical_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.keyvault/vaults"
      criteria_metric_name      = "Availability"
      criteria_aggregation      = "Average"
      criteria_operator         = "LessThanOrEqual"
      criteria_threshold        = var.keyvault_availability_critical_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "microsoft.keyvault/vaults"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-critical,
    module.admin-key-vault
  ]
}

module "admin-key-vault-availability-warning-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "admin_key_vault_warning_alerts" = {
      scopes                    = [module.admin-key-vault.vault_id]
      reason                    = "WarningAdminKeyVaultAvailabilityDecreased"
      description               = "[WARNING] Average availability of the Admin Key vault has dropped to ${var.keyvault_availability_warning_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.keyvault/vaults"
      criteria_metric_name      = "Availability"
      criteria_aggregation      = "Average"
      criteria_operator         = "LessThanOrEqual"
      criteria_threshold        = var.keyvault_availability_warning_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "microsoft.keyvault/vaults"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-warning,
    module.admin-key-vault
  ]
}

module "development-key-vault-availability-critical-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "development_key_vault_critical_alerts" = {
      scopes                    = [module.deve-key-vault.vault_id]
      reason                    = "CriticalDevelopmentKeyVaultAvailabilityDecreased"
      description               = "[CRITICAL] Average availability of the Development Key vault has dropped to ${var.keyvault_availability_critical_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.keyvault/vaults"
      criteria_metric_name      = "Availability"
      criteria_aggregation      = "Average"
      criteria_operator         = "LessThanOrEqual"
      criteria_threshold        = var.keyvault_availability_critical_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_critical
      target_resource_type      = "microsoft.keyvault/vaults"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-critical,
    module.deve-key-vault
  ]
}

module "development-key-vault-availability-warning-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "development_key_vault_warning_alerts" = {
      scopes                    = [module.deve-key-vault.vault_id]
      reason                    = "WarningDevelopmentKeyVaultAvailabilityDecreased"
      description               = "[WARNING] Average availability of the Development Key vault has dropped to ${var.keyvault_availability_warning_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.keyvault/vaults"
      criteria_metric_name      = "Availability"
      criteria_aggregation      = "Average"
      criteria_operator         = "LessThanOrEqual"
      criteria_threshold        = var.keyvault_availability_warning_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "microsoft.keyvault/vaults"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-warning,
    module.deve-key-vault
  ]
}

module "development-key-vault-latency-critical-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "development_key_vault_latency_critical_alerts" = {
      scopes                    = [module.deve-key-vault.vault_id]
      reason                    = "CriticalDevelopmentKeyVaultAPILatencyLimitExceeded"
      description               = "[CRITICAL] Average service API latency of the Development Key vault has exceeded it's limit which is ${var.keyvault_latency_critical_threshold}ms during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.keyvault/vaults"
      criteria_metric_name      = "ServiceApiLatency"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      criteria_threshold        = var.keyvault_latency_critical_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_critical
      target_resource_type      = "microsoft.keyvault/vaults"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-critical,
    module.deve-key-vault
  ]
}

module "development-key-vault-latency-warning-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "development_key_vault_latency_warning_alerts" = {
      scopes                    = [module.deve-key-vault.vault_id]
      reason                    = "WarningDevelopmentKeyVaultAPILatencyLimitExceeded"
      description               = "[WARNING] Average service API latency of the Development Key vault has exceeded it's limit which is ${var.keyvault_latency_warning_threshold}ms during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.keyvault/vaults"
      criteria_metric_name      = "ServiceApiLatency"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      criteria_threshold        = var.keyvault_latency_warning_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "microsoft.keyvault/vaults"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-warning,
    module.deve-key-vault
  ]
}

module "key-vault-saturation-warning-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {

  }
  metric_alerts_with_1_dimension = {
    "development_key_vault_saturation_warning_alert" = {
      scopes                    = [module.deve-key-vault.vault_id]
      reason                    = "WarningDevelopmenetKeyVaultSaturationLimitExceeded"
      description               = "[WARNING] Average saturation of the Development Key vault has exceeded it's limit which is ${var.keyvault_saturation_threshold_warning}% during the last 5 minutes. You may click on the Alert ID to get more details."
      monitor_action_group_id   = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "Microsoft.KeyVault/vaults"
      criteria_metric_namespace = "Microsoft.KeyVault/vaults"
      criteria_metric_name      = "SaturationShoebox"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      criteria_threshold        = var.keyvault_saturation_threshold_warning
      dimension_1_name          = "TransactionType"
      dimension_1_operator      = "Include"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
      dimension_1_values = [
        "vaultoperation"
      ]
    },
    "development_key_vault_saturation_critical_alert" = {
      scopes                    = [module.deve-key-vault.vault_id]
      reason                    = "CriticalDevelopmenetKeyVaultSaturationLimitExceeded"
      description               = "[CRITICAL] Average saturation of the Development Key vault has exceeded it's limit which is ${var.keyvault_saturation_threshold_critical}% during the last 5 minutes. You may click on the Alert ID to get more details."
      monitor_action_group_id   = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_critical
      target_resource_type      = "Microsoft.KeyVault/vaults"
      criteria_metric_namespace = "Microsoft.KeyVault/vaults"
      criteria_metric_name      = "SaturationShoebox"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      criteria_threshold        = var.keyvault_saturation_threshold_critical
      dimension_1_name          = "TransactionType"
      dimension_1_operator      = "Include"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
      dimension_1_values = [
        "vaultoperation"
      ]
    },
    "admin_key_vault_saturation_warning_alert" = {
      scopes                    = [module.admin-key-vault.vault_id]
      reason                    = "WarningAdminKeyVaultSaturationLimitExceeded"
      description               = "[WARNING] Average saturation of the Admin Key vault has exceeded it's limit which is ${var.keyvault_saturation_threshold_warning}% during the last 5 minutes. You may click on the Alert ID to get more details."
      monitor_action_group_id   = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "Microsoft.KeyVault/vaults"
      criteria_metric_namespace = "Microsoft.KeyVault/vaults"
      criteria_metric_name      = "SaturationShoebox"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      criteria_threshold        = var.keyvault_saturation_threshold_warning
      dimension_1_name          = "TransactionType"
      dimension_1_operator      = "Include"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
      dimension_1_values = [
        "vaultoperation"
      ]
    },
    "admin_key_vault_saturation_p3_alert" = {
      scopes                    = [module.admin-key-vault.vault_id]
      reason                    = "P3-AdminKeyVaultSaturationLimitExceeded"
      description               = "[P3] Average saturation of the Admin Key vault has exceeded it's limit which is ${var.keyvault_saturation_threshold_critical}% during the last 5 minutes. You may click on the Alert ID to get more details."
      monitor_action_group_id   = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "Microsoft.KeyVault/vaults"
      criteria_metric_namespace = "Microsoft.KeyVault/vaults"
      criteria_metric_name      = "SaturationShoebox"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      criteria_threshold        = var.keyvault_saturation_threshold_critical
      dimension_1_name          = "TransactionType"
      dimension_1_operator      = "Include"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
      dimension_1_values = [
        "vaultoperation"
      ]
    }
  }
  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-warning,
    module.monitoring-alerts-action-group-critical,
    module.deve-key-vault,
    module.admin-key-vault
  ]
}

## File storage account

module "fileshare-is-share-used-capacity-critical-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "file_share_used_capacity_critical_alert" = {
      scopes                    = [module.premium-fileshare-storage-account.storage_account_id]
      reason                    = "CriticalISFileshareStorageCapacityUsedLimitExceeded"
      description               = "[CRITICAL] IS Fileshare storage account has reached it's maximum average of used capacity which is ${var.is_fileshare_used_capacity_critical_threshold / 1073741824}GB during the last hour. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.storage/storageaccounts"
      criteria_metric_name      = "UsedCapacity"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      # criteria_threshold value should in Bytes
      criteria_threshold      = var.is_fileshare_used_capacity_critical_threshold
      monitor_action_group_id = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency               = "PT1M"
      severity                = var.alert_severity_critical
      target_resource_type    = "microsoft.storage/storageaccounts"
      window_size             = "PT1H"
      alert_enabled           = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-critical,
    module.premium-fileshare-is-share
  ]
}

module "fileshare-is_share-used-capacity-alerts-warning" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project
  metric_alerts = {
    "file_share_used_capacity_warning_alert" = {
      scopes                    = [module.premium-fileshare-storage-account.storage_account_id]
      reason                    = "WarningISFileshareStorageCapacityUsedLimitExceeded"
      description               = "[WARNING] IS Fileshare storage account has reached it's average of used capacity which is ${var.is_fileshare_used_capacity_warning_threshold / 1073741824}GB during the last hour. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.storage/storageaccounts"
      criteria_metric_name      = "UsedCapacity"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      # criteria_threshold value should in Bytes
      criteria_threshold      = var.is_fileshare_used_capacity_warning_threshold
      monitor_action_group_id = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency               = "PT1M"
      severity                = var.alert_severity_warning
      target_resource_type    = "microsoft.storage/storageaccounts"
      window_size             = "PT1H"
      alert_enabled           = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-warning,
    module.premium-fileshare-is-share
  ]
}

module "fileshare-is-share-availability-critical-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "file_share_availability_critical_alert" = {
      scopes                    = [module.premium-fileshare-storage-account.storage_account_id]
      reason                    = "CriticalISFileshareAvailabilityDecreased"
      description               = "[CRITICAL] Average availability of the IS Fileshare storage account has dropped to ${var.is_file_share_availability_critical_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.storage/storageaccounts"
      criteria_metric_name      = "Availability"
      criteria_aggregation      = "Average"
      criteria_operator         = "LessThanOrEqual"
      criteria_threshold        = var.is_file_share_availability_critical_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_critical
      target_resource_type      = "microsoft.storage/storageaccounts"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-critical,
    module.premium-fileshare-is-share
  ]
}

module "fileshare-is-share-availability-warning-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "file_share_availability_warning_alert" = {
      scopes                    = [module.premium-fileshare-storage-account.storage_account_id]
      reason                    = "WarningISFileshareAvailabilityDecreased"
      description               = "[WARNING] Average availability of the IS Fileshare storage account has dropped to ${var.is_file_share_availability_warning_threshold}% during the last 5 minutes. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.storage/storageaccounts"
      criteria_metric_name      = "Availability"
      criteria_aggregation      = "Average"
      criteria_operator         = "LessThanOrEqual"
      criteria_threshold        = var.is_file_share_availability_warning_threshold
      monitor_action_group_id   = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency                 = "PT1M"
      severity                  = var.alert_severity_warning
      target_resource_type      = "microsoft.storage/storageaccounts"
      window_size               = "PT5M"
      alert_enabled             = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-warning,
    module.premium-fileshare-is-share
  ]
}

module "fileshare-is-share-metric-alerts" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts?ref=v0.1.0"
  tags                = local.default_tags
  resource_group_name = module.spoke-resource-group.resource_group_name
  location            = var.location
  environment         = var.environment
  padding             = var.padding
  project             = var.project

  metric_alerts = {
    "file_share_e2e_latency_critical_alert" = {
      scopes                    = [module.premium-fileshare-storage-account.storage_account_id]
      reason                    = "CriticalISFileshareE2EAverageLatencyIncreased"
      description               = "[CRITICAL] Average Latency of IS Fileshare has increased to ${var.is_file_share_e2e_latency_critical_threshold}ms during the last hour. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.storage/storageaccounts"
      criteria_metric_name      = "SuccessE2ELatency"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      # criteria_threshold is in milli seconds
      criteria_threshold      = var.is_file_share_e2e_latency_critical_threshold
      monitor_action_group_id = module.monitoring-alerts-action-group-critical.monitor_action_group_id
      frequency               = "PT1M"
      severity                = var.alert_severity_critical
      target_resource_type    = "microsoft.storage/storageaccounts"
      window_size             = "PT1H"
      alert_enabled           = var.metric_alert_enabled
    }
    "file_share_e2e_latency_warning_alert" = {
      scopes                    = [module.premium-fileshare-storage-account.storage_account_id]
      reason                    = "WarningISFileshareE2EAverageLatencyIncreased"
      description               = "[WARNING] Average Latency of IS Fileshare has increased to ${var.is_file_share_e2e_latency_warning_threshold}ms during the last hour. You may click on the Alert ID to get more details."
      criteria_metric_namespace = "microsoft.storage/storageaccounts"
      criteria_metric_name      = "SuccessE2ELatency"
      criteria_aggregation      = "Average"
      criteria_operator         = "GreaterThan"
      # criteria_threshold is in milli seconds
      criteria_threshold      = var.is_file_share_e2e_latency_warning_threshold
      monitor_action_group_id = module.monitoring-alerts-action-group-warning.monitor_action_group_id
      frequency               = "PT1M"
      severity                = var.alert_severity_warning
      target_resource_type    = "microsoft.storage/storageaccounts"
      window_size             = "PT1H"
      alert_enabled           = var.metric_alert_enabled
    }
  }

  metric_alerts_with_1_dimension = {

  }

  metric_alerts_with_2_dimensions = {

  }
  depends_on = [
    module.spoke-resource-group,
    module.monitoring-alerts-action-group-critical,
    module.premium-fileshare-is-share
  ]
}


