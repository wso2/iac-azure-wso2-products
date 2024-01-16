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

variable "project" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The name of the environment e.g. staging,prod"
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

variable "hub_name" {
  description = "The name of the hub"
  type        = string
  default     = "hub"
}

variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "The Azure subscription tenant ID"
  type        = string
}

## Virtual Network
variable "virtual_network_address_space" {
  description = "The CIDR of the Virtual Network"
  type        = string
}

variable "firewall_zones" {
  description = "The firewall zones"
  type        = list(string)
}

variable "firewall_network_rule_collection_priority" {
  description = "Priority of network rule collection"
  type        = number
  default     = 300
}

variable "scale_set_agents_subnet_address_prefixes" {
  description = "Scale set agents subnet address prefixes"
  type        = list(string)
}

variable "firewall_subnet_address_prefix" {
  description = "Firewall subnet address prefix"
  type        = string
}

variable "bastion_host_subnet_address_prefix" {
  description = "Bastion host subnet address prefix"
  type        = string
}

variable "log_analytics_workspace_sku" {
  description = "The sku of the log analytics workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_workspace_internet_ingestion_enabled" {
  description = "Should the Log Analytics Workspace support ingestion over the Public Internet?"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_internet_query_enabled" {
  description = "Should the Log Analytics Workspace support querying over the Public Internet?"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_log_retention_in_days" {
  description = "The log retention in days"
  type        = string
}

variable "devops_scale_set_agents_admin_username" {
  description = "Admin username of the scale set agents"
  type        = string
}

variable "devops_scale_set_agents_sku" {
  description = "Scale set agents SKU"
  type        = string
  default     = "Standard_D4as_v4"
}

variable "devops_scale_set_agents_source_image_id" {
  description = "The source image ID of the scale set agent image."
  type        = string
}

variable "devops_scale_set_agents_subnet_service_endpoints" {
  description = "Scale set agents subnet service endpoints"
  type        = list(string)
}

variable "wso2_lk_office_outbound_ip" {
  description = "The outbound IP address of the WSO2 LK office"
  type        = string
}

variable "wso2_us_vpn_outbound_ip" {
  description = "The outbound IP address of the WSO2 US VPN"
  type        = string
}

variable "front_door_waf_object" {
  type        = map(any)
  description = "WAF policy configuration"
  default     = {}
}

variable "private_link_scope_workload_name" {
  description = "private link scope workload name"
  type        = string
  default     = "private-la"
}

variable "role_definition_name_reader" {
  description = "Role definition name reader"
  type        = string
  default     = "Reader"
}

variable "public_ip_prefix_length" {
  description = "Public IP Prefix Length"
  type        = number
  default     = 30
}

variable "firewall_network_rule_collection_name_allow" {
  description = "Firewall Network Rule Collection Name Workload Name"
  type        = string
  default     = "allow"
}

variable "bastion_host_sku" {
  description = "Bastion Host SKU"
  type        = string
  default     = "Standard"
}

variable "allow_bastion_https_internet_inbound" {
  description = "Allow HTTPS Internet Inbound for bastion host"
  type        = bool
  default     = false
}

variable "bastion_file_copy_enabled" {
  description = "File Copy Enabled for bastion host"
  type        = bool
  default     = true
}

variable "bastion_tunneling_enabled" {
  description = "Tunneling Enabled for bastion host"
  type        = bool
  default     = true
}

variable "bastion_admin_ad_group_workload_name" {
  description = "Bastion Admin AD Group Workload Name"
  type        = string
  default     = "bastion-admin"
}

variable "bastion_user_ad_group_workload_name" {
  description = "Bastion User AD Group Workload Name"
  type        = string
  default     = "bastion-user"
}

variable "devops_scale_set_agents_workload_name" {
  description = "Scale Set Agents Workload Name"
  type        = string
  default     = "scaleset"
}

variable "devops_scale_set_agents_admin_ssh_public_key" {
  description = "Scale Set Agents Admin SSH Public Key"
  type        = string
}

variable "firewall_egress_route_workload_name" {
  description = "Firewall Egress Route Workload Name"
  type        = string
  default     = "firewallegress"
}

variable "firewall_public_ips" {
  description = "Firewall Public IPs"
  type = map(object({
    public_ip_name         = string
    private_ip_address     = string
    fw_ip_association_name = string
  }))
}

variable "private_endpoint_subnet_workload_name_ampls" {
  description = "AMPLS private endpoint subnet workload name"
  type        = string
  default     = "ampls"
}

variable "private_endpoint_subnet_workload_name" {
  description = "Private endpoint subnet workload name"
  type        = string
  default     = "private-endpoint"
}

### Private endpoint subnet
variable "private_endpoint_subnet_address_prefix" {
  description = "Private Endpoint Subnet Address Prefix"
  type        = string
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

variable "firewall_snat_port_utilization_percent_critical_threshold" {
  description = "Firewall SNAT port utilization percent for critical alert"
  type        = string
  default     = 95
}

variable "firewall_snat_port_utilization_percent_warning_threshold" {
  description = "Firewall SNAT port utilization percent for warning alert"
  type        = string
  default     = 80
}

variable "firewall_health_state_critical_threshold" {
  description = "Firewall health state for critical alert"
  type        = string
  default     = 80
}

variable "firewall_health_state_warning_threshold" {
  description = "Firewall health state percent for warning alert"
  type        = string
  default     = 95
}

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
