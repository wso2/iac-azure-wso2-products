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

variable "hub_name" {
  description = "The name of the hub"
  type        = string
  default     = "hub"
}

variable "hub_environment" {
  description = "The name of the hub environment"
  type        = string
}

variable "spoke_name" {
  description = "The name of the spoke layer"
  type        = string
  default     = "spoke"
}

variable "project" {
  description = "The name of the project"
  type        = string
}
variable "location" {
  description = "The Azure region to deploy"
  type        = string
}

variable "padding" {
  description = "Padding for the deployment"
  type        = string
}

variable "environment" {
  description = "The name of the environment e.g. staging,prod"
  type        = string
}

variable "shortened_project" {
  description = "Shortened version of project"
  type        = string
}

variable "shortened_environment" {
  description = "Shortened version of environment"
  type        = string
}

variable "shortened_location" {
  description = "Shortened version of location"
  type        = string
}

variable "shortened_padding" {
  description = "Shortened version of padding"
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "hub_subscription_id" {
  description = "The Azure subscription ID for Hub"
  type        = string
}

variable "tenant_id" {
  description = "The Azure subscription tenant ID"
  type        = string
}

# Virtual Network
variable "virtual_network_address_space" {
  description = "The CIDR of the Virtual Network"
  type        = string
}

variable "firewall_subnet_address_prefix" {
  description = "Firewall Subnet Address Prefix"
  type        = string
}

variable "firewall_private_ip" {
  description = "Firewall private IP"
  type        = string
}

variable "vmss_workload_subnet_address_prefix" {
  description = "The subnet CIDR of VMSS"
  type        = string
}

variable "vnet_peering_allow_virtual_src_network_access" {
  description = "Option allow_virtual_network_access for the src vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = true
}

variable "vnet_peering_allow_forwarded_src_traffic" {
  description = "Option allow_forwarded_traffic for the src vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = true
}

variable "vnet_peering_allow_gateway_src_transit" {
  description = "Option allow_gateway_transit for the src vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = true
}

variable "vnet_peering_use_remote_src_gateway" {
  description = "Option use_remote_gateway for the src vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}

variable "vnet_peering_allow_virtual_dest_network_access" {
  description = "Option allow_virtual_network_access for the dest vnet to peer. Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_virtual_network_access"
  type        = bool
  default     = true
}

variable "vnet_peering_allow_forwarded_dest_traffic" {
  description = "Option allow_forwarded_traffic for the dest vnet to peer. Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_forwarded_traffic"
  type        = bool
  default     = false
}

variable "vnet_peering_allow_gateway_dest_transit" {
  description = "Option allow_gateway_transit for the dest vnet to peer. Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#allow_gateway_transit"
  type        = bool
  default     = false
}

variable "vnet_peering_use_remote_dest_gateway" {
  description = "Option use_remote_gateway for the dest vnet to peer. Controls if remote gateways can be used on the local virtual network. https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways"
  type        = bool
  default     = false
}

variable "bastion_source_image_id" {
  description = "VM Image ID to be used to create the VM"
  type        = string
}

variable "bastion_admin_username" {
  description = "Bastion admin username"
  type        = string
}

variable "bastion_managed_disk_size_gb" {
  description = "Bastion attached managed disk size"
  type        = string
}

variable "bastion_os_disk_size_gb" {
  description = "Bastion OS disk size"
  type        = string
}

variable "bastion_size" {
  description = "Bastion VM size"
  type        = string
}

variable "bastion_subnet_enforce_private_link_endpoint_network_policies" {
  description = "Enforce private link endpoint network policies"
  type        = bool
  default     = false
}

variable "bastion_vm_subnet_address_prefix" {
  description = "Bastion vm subnet address prefix"
  type        = string
}

### Private endpoint subnet
variable "private_endpoint_subnet_address_prefix" {
  description = "Private Endpoint Subnet Address Prefix"
  type        = string
}

variable "bastion_admin_group_id" {
  description = "Bastion admin group id"
  type        = string
}

variable "bastion_user_group_id" {
  description = "Bastion user group id"
  type        = string
}

# Admin Keyvault
variable "admin_key_vault_sku_name" {
  description = "Admin Key vault Name"
  type        = string
  default     = "standard"
}

variable "admin_key_vault_soft_delete_retention_days" {
  description = "Admin Key vault soft delete retention days"
  type        = number
  default     = 90
}

variable "admin_key_vault_application_name" {
  description = "Admin Key vault application name"
  type        = string
  default     = "admin"
}

variable "private_endpoint_subnet_workload_name_admin_key_vault" {
  description = "Admin Keyvault private endpoint subnet workload name"
  type        = string
  default     = "adminkeyvault"
}

# Development Keyvault
variable "development_key_vault_sku_name" {
  description = "Dev Key vault Name"
  type        = string
  default     = "standard"
}

variable "development_key_vault_soft_delete_retention_days" {
  description = "Development Key vault soft delete retention days"
  type        = number
  default     = 90
}

variable "development_key_vault_application_name" {
  description = "Dev Key vault application name"
  type        = string
  default     = "deve"
}

variable "private_endpoint_subnet_workload_name_development_key_vault" {
  description = "Development Keyvault private endpoint subnet workload name"
  type        = string
  default     = "developmentkeyvault"
}

variable "key_vault_cluster_product_ad_application_name" {
  description = "Azure Active Directory cluster product application name for Dev Key vault"
  type        = string
  default     = "deve-key-vault-cluster-product-ad-application"
}

variable "key_vault_cluster_product_ad_sp_access_key_permissions" {
  description = "Azure Active Directory cluster product application name for Dev Key vault"
  type        = list(string)
  default     = []
}

variable "key_vault_cluster_product_ad_sp_access_secret_permissions" {
  description = "Azure Active Directory cluster product application name for Dev Key vault"
  type        = list(string)
  default     = ["Get", "List"]
}

variable "key_vault_cluster_product_ad_sp_access_certificate_permissions" {
  description = "Azure Active Directory cluster product application name for Dev Key vault"
  type        = list(string)
  default     = []
}

## Admin Deve key vault SP
variable "admin_deve_kv_dev_ops_ad_application_name" {
  description = "Azure Active Directory Admin Deve key vault application name"
  type        = string
  default     = "dev-ops-admin-deve-key-vault-ad-application"
}

variable "subscription_name" {
  description = "The name of the Azure Subscription"
  type        = string
}

variable "key_vault_dev_ops_ad_sp_access_key_permissions" {
  description = "Azure Active Directory DevOPS application Key permissions for Dev Key vault"
  type        = list(string)
  default     = ["Get", "List", "Create"]
}

variable "key_vault_dev_ops_ad_sp_access_secret_permissions" {
  description = "Azure Active Directory DevOPS application Secret permissions for Dev Key vault"
  type        = list(string)
  default     = ["Get", "List", "Set"]
}

variable "key_vault_dev_ops_ad_sp_access_certificate_permissions" {
  description = "Azure Active Directory DevOPS application Certificate permissions for Dev Key vault"
  type        = list(string)
  default     = ["Get", "List", "Create", "Import"]
}


## Premium fileshare storage
variable "fileshare_storage_account_replication_type" {
  description = "Replication type of the fileshare storage account"
  type        = string
}

variable "fileshare_storage_account_tier" {
  description = "Account tier of the fileshare storage account"
  type        = string
  default     = "Premium"
}

variable "fileshare_storage_application_name" {
  description = "Application name of the fileshare storage account"
  type        = string
  default     = "is"
}

variable "advanced_threat_protection_enabled" {
  description = "Enable Advance Threat protection for Storage account"
  type        = bool
  default     = false
}

variable "key_vault_tf_ad_group_access_key_permissions" {
  description = "Key vault terraform ad group access key permissions"
  type        = list(string)
  default     = []
}

variable "key_vault_tf_ad_group_access_secret_permissions" {
  description = "Key vault terraform ad group access secret permissions"
  type        = list(string)
  default     = ["Get", "List", "Set", "Delete"]
}

variable "key_vault_tf_ad_group_access_certificate_permissions" {
  description = "Key vault terraform ad group access certificate permissions"
  type        = list(string)
  default     = []
}

variable "private_network_allow_ip_list" {
  description = "Allow IP address list for private resources"
  type        = list(string)
}

variable "private_endpoint_subnet_workload_name_fileshare" {
  description = "Storage account private endpoint subnet workload name"
  type        = string
  default     = "storageaccountfileshare"
}

### is fileshare
variable "is_fileshare_name" {
  description = "IS fileshare name"
  type        = string
  default     = "is-share"
}

variable "is_fileshare_quote" {
  description = "IS fileshare quote"
  type        = string
  default     = "100"
}

variable "firewall_network_rule_collection_name_allow" {
  description = "Firewall Network Rule Collection Name Workload Name"
  type        = string
  default     = "allow"
}

variable "firewall_network_rule_collection_priority_allow" {
  description = "Firewall Network Rule Collection Priority Allow"
  type        = number
  default     = 301
}

variable "firewall_application_rule_collection_name_allow" {
  description = "Firewall Application Rule Collection Name Workload Name"
  type        = string
  default     = "allow"
}

variable "firewall_application_rule_collection_priority_allow" {
  description = "Firewall Application Rule Collection Priority Allow"
  type        = number
  default     = 101
}

variable "bastion_public_key_path" {
  description = "Bastion public key path"
  type        = string
}


variable "firewall_nat_rule_collection_priority" {
  description = "Firewall NAT Rule Collection Priority Allow"
  type        = number
  default     = 101
}

variable "firewall_nat_rule_collection_name_allow" {
  description = "Firewall NAT Rule Collection Name Workload Name"
  type        = string
  default     = "allow"
}

variable "private_endpoint_subnet_workload_name" {
  description = "Private endpoint subnet workload name"
  type        = string
  default     = "private-endpoint"
}

variable "bastion_storage_account_workload_name" {
  description = "Bastion storage account workload name"
  type        = string
  default     = "storageaccountbastion"
}

variable "firewall_dynamic_dnat_rules" {
  description = "Dynamic DNAT Rules"
  type = map(object({
    public_ip_address = string
  }))
}

variable "firewall_dynamic_dnat_rules_lb_private_ip_address" {
  description = "LB private address for firewall dynamic DNAT Rules"
  type        = string
}

variable "dns_zone_name" {
  description = "DNS Zone Name"
  type        = string
}

variable "dns_record_name" {
  description = "Record Name"
  type        = string
}

variable "dns_ttl" {
  description = "TTL"
  type        = number
  default     = 3600
}

variable "dns_records" {
  description = "Records"
  type        = list(string)
}

# Alerts
variable "alert_severity_critical" {
  description = "Severity of the critical alert"
  type        = number
  default     = 0
}

variable "alert_severity_warning" {
  description = "Severity of the warning alert"
  type        = number
  default     = 2
}

variable "metric_alert_enabled" {
  description = "Enable metric alerts"
  type        = bool
  default     = false
}

variable "alert_percentage_threshold_warning" {
  description = "Percentage threshold for warning alert"
  type        = number
  default     = 80
}

variable "alert_percentage_threshold_critical" {
  description = "Percentage threshold for critical alert"
  type        = number
  default     = 95
}

variable "monitoring_alerts_actions_emails_critical" {
  description = "List of the email receives for Critical alerts"
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = bool
  }))
}

variable "monitoring_alerts_actions_emails_warning" {
  description = "List of the email receives for Warning alerts"
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = bool
  }))
}

variable "keyvault_saturation_threshold_critical" {
  description = "Key vault saturation critical threshold"
  type        = number
  default     = 95.0
}

variable "keyvault_saturation_threshold_warning" {
  description = "Warning Key vault saturation warning threshold"
  type        = number
  default     = 80.0
}

variable "keyvault_latency_critical_threshold" {
  description = "Key vault latency critical threshold"
  type        = number
  default     = 5000
}

variable "keyvault_latency_warning_threshold" {
  description = "Key vault latency warning threshold"
  type        = number
  default     = 3000
}

variable "keyvault_availability_critical_threshold" {
  description = "Key vault availability critical threshold"
  type        = number
  default     = 80.0
}

variable "keyvault_availability_warning_threshold" {
  description = "Key vault availability warning threshold"
  type        = number
  default     = 95.0
}

variable "is_fileshare_used_capacity_critical_threshold" {
  description = "IS file share used capacity critical threshold"
  type        = number
  default     = 102005473280.0 #95GB
}

variable "is_fileshare_used_capacity_warning_threshold" {
  description = "IS file share used capacity warning threshold"
  type        = number
  default     = 85899345920.0 #80GB
}

variable "is_file_share_availability_critical_threshold" {
  description = "IS file share availability critical threshold"
  type        = number
  default     = 80.0
}

variable "is_file_share_availability_warning_threshold" {
  description = "IS file share availability warning threshold"
  type        = number
  default     = 95.0
}

variable "is_file_share_e2e_latency_critical_threshold" {
  description = "IS file share e2e latency critical threshold"
  type        = number
  default     = 200
}

variable "is_file_share_e2e_latency_warning_threshold" {
  description = "IS file share e2e latency warning threshold"
  type        = number
  default     = 110
}

variable "service_health_error_alert_target_locations" {
  description = "Locations for service health alert"
  type        = list(string)
}

variable "service_health_error_alert_target_events" {
  description = "Target events for service health error alert"
  type        = list(string)
  default     = ["Incident"]
}