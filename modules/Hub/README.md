## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.14.10 |


## Providers

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | = 2.14.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.52.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion-admin-ad-group"></a> [bastion-admin-ad-group](#module\_bastion-admin-ad-group) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Group | v0.5.0 |
| <a name="module_bastion-host"></a> [bastion-host](#module\_bastion-host) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Bastion-Host | v0.5.0 |
| <a name="module_bastion-host-rbac-bastion-admin-ad-group-reader"></a> [bastion-host-rbac-bastion-admin-ad-group-reader](#module\_bastion-host-rbac-bastion-admin-ad-group-reader) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment | v0.5.0 |
| <a name="module_bastion-host-rbac-bastion-user-ad-group-reader"></a> [bastion-host-rbac-bastion-user-ad-group-reader](#module\_bastion-host-rbac-bastion-user-ad-group-reader) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Role-Assignment | v0.5.0 |
| <a name="module_bastion-user-ad-group"></a> [bastion-user-ad-group](#module\_bastion-user-ad-group) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azuread/Group | v0.5.0 |
| <a name="module_fdwafpolicy"></a> [fdwafpolicy](#module\_fdwafpolicy) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/FrontDoor-WAF | v0.5.0 |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Firewall | v0.5.0 |
| <a name="module_firewall-allow-network-rule"></a> [firewall-allow-network-rule](#module\_firewall-allow-network-rule) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Firewall-Network-Rules | v0.5.0 |
| <a name="module_fw-snat-port-utilization-percent-monitoring-alerts"></a> [fw-snat-port-utilization-percent-monitoring-alerts](#module\_fw-snat-port-utilization-percent-monitoring-alerts) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Metric-Alerts | v0.5.0 |
| <a name="module_hub-resource-group"></a> [hub-resource-group](#module\_hub-resource-group) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Resource-Group | v0.5.0 |
| <a name="module_hub-virtual-network"></a> [hub-virtual-network](#module\_hub-virtual-network) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Virtual-Network | v0.5.0 |
| <a name="module_log-analytics-workspace"></a> [log-analytics-workspace](#module\_log-analytics-workspace) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Log-Analytics-Workspace | v0.5.0 |
| <a name="module_monitor-private-link-scope"></a> [monitor-private-link-scope](#module\_monitor-private-link-scope) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Azure-Monitor-Private-Link-Scope | v0.5.0 |
| <a name="module_monitor-private-link-scope-private-endpoint"></a> [monitor-private-link-scope-private-endpoint](#module\_monitor-private-link-scope-private-endpoint) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-Endpoint | v0.5.0 |
| <a name="module_monitor-private-link-scope-service"></a> [monitor-private-link-scope-service](#module\_monitor-private-link-scope-service) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Azure-Monitor-Private-Link-Scope-Service | v0.5.0 |
| <a name="module_monitoring-alerts-action-group-critical"></a> [monitoring-alerts-action-group-critical](#module\_monitoring-alerts-action-group-critical) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Action-Groups | v0.5.0 |
| <a name="module_monitoring-alerts-action-group-warning"></a> [monitoring-alerts-action-group-warning](#module\_monitoring-alerts-action-group-warning) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Monitor-Action-Groups | v0.5.0 |
| <a name="module_private-dns-azure-automation"></a> [private-dns-azure-automation](#module\_private-dns-azure-automation) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone | v0.5.0 |
| <a name="module_private-dns-azure-monitor"></a> [private-dns-azure-monitor](#module\_private-dns-azure-monitor) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone | v0.5.0 |
| <a name="module_private-dns-azure-monitor-ods"></a> [private-dns-azure-monitor-ods](#module\_private-dns-azure-monitor-ods) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone | v0.5.0 |
| <a name="module_private-dns-azure-monitor-oms"></a> [private-dns-azure-monitor-oms](#module\_private-dns-azure-monitor-oms) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone | v0.5.0 |
| <a name="module_private-dns-blob"></a> [private-dns-blob](#module\_private-dns-blob) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone | v0.5.0 |
| <a name="module_private-dns-fileshare"></a> [private-dns-fileshare](#module\_private-dns-fileshare) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone | v0.5.0 |
| <a name="module_private-dns-key-vault"></a> [private-dns-key-vault](#module\_private-dns-key-vault) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-DNS-Zone | v0.5.0 |
| <a name="module_private-endpoint-subnet"></a> [private-endpoint-subnet](#module\_private-endpoint-subnet) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Private-EndPoint-Subnet | v0.5.0 |
| <a name="module_public-ip-prefix"></a> [public-ip-prefix](#module\_public-ip-prefix) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Public-IP-Prefix | v0.5.0 |
| <a name="module_scale-set-agents"></a> [scale-set-agents](#module\_scale-set-agents) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Azure-DevOps-Custom-Image-Scale-Set-Agents | v0.5.0 |
| <a name="module_scale-set-agents-firewall-egress-route"></a> [scale-set-agents-firewall-egress-route](#module\_scale-set-agents-firewall-egress-route) | git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/Route-Table-Firewall-Egress | v0.5.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_severity_critical"></a> [alert\_severity\_critical](#input\_alert\_severity\_critical) | Severity of the critical alert | `number` | `0` | no |
| <a name="input_alert_severity_warning"></a> [alert\_severity\_warning](#input\_alert\_severity\_warning) | Severity of the warning alert | `number` | `2` | no |
| <a name="input_allow_bastion_https_internet_inbound"></a> [allow\_bastion\_https\_internet\_inbound](#input\_allow\_bastion\_https\_internet\_inbound) | Allow HTTPS Internet Inbound for bastion host | `bool` | `false` | no |
| <a name="input_bastion_admin_ad_group_workload_name"></a> [bastion\_admin\_ad\_group\_workload\_name](#input\_bastion\_admin\_ad\_group\_workload\_name) | Bastion Admin AD Group Workload Name | `string` | `"bastion-admin"` | no |
| <a name="input_bastion_file_copy_enabled"></a> [bastion\_file\_copy\_enabled](#input\_bastion\_file\_copy\_enabled) | File Copy Enabled for bastion host | `bool` | `true` | no |
| <a name="input_bastion_host_sku"></a> [bastion\_host\_sku](#input\_bastion\_host\_sku) | Bastion Host SKU | `string` | `"Standard"` | no |
| <a name="input_bastion_host_subnet_address_prefix"></a> [bastion\_host\_subnet\_address\_prefix](#input\_bastion\_host\_subnet\_address\_prefix) | Bastion host subnet address prefix | `string` | n/a | yes |
| <a name="input_bastion_tunneling_enabled"></a> [bastion\_tunneling\_enabled](#input\_bastion\_tunneling\_enabled) | Tunneling Enabled for bastion host | `bool` | `true` | no |
| <a name="input_bastion_user_ad_group_workload_name"></a> [bastion\_user\_ad\_group\_workload\_name](#input\_bastion\_user\_ad\_group\_workload\_name) | Bastion User AD Group Workload Name | `string` | `"bastion-user"` | no |
| <a name="input_devops_scale_set_agents_admin_ssh_public_key"></a> [devops\_scale\_set\_agents\_admin\_ssh\_public\_key](#input\_devops\_scale\_set\_agents\_admin\_ssh\_public\_key) | Scale Set Agents Admin SSH Public Key | `string` | n/a | yes |
| <a name="input_devops_scale_set_agents_admin_username"></a> [devops\_scale\_set\_agents\_admin\_username](#input\_devops\_scale\_set\_agents\_admin\_username) | Admin username of the scale set agents | `string` | n/a | yes |
| <a name="input_devops_scale_set_agents_sku"></a> [devops\_scale\_set\_agents\_sku](#input\_devops\_scale\_set\_agents\_sku) | Scale set agents SKU | `string` | `"Standard_D4as_v4"` | no |
| <a name="input_devops_scale_set_agents_source_image_id"></a> [devops\_scale\_set\_agents\_source\_image\_id](#input\_devops\_scale\_set\_agents\_source\_image\_id) | The source image ID of the scale set agent image. | `string` | n/a | yes |
| <a name="input_devops_scale_set_agents_subnet_service_endpoints"></a> [devops\_scale\_set\_agents\_subnet\_service\_endpoints](#input\_devops\_scale\_set\_agents\_subnet\_service\_endpoints) | Scale set agents subnet service endpoints | `list(string)` | n/a | yes |
| <a name="input_devops_scale_set_agents_workload_name"></a> [devops\_scale\_set\_agents\_workload\_name](#input\_devops\_scale\_set\_agents\_workload\_name) | Scale Set Agents Workload Name | `string` | `"scaleset"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment e.g. staging,prod | `string` | n/a | yes |
| <a name="input_firewall_egress_route_workload_name"></a> [firewall\_egress\_route\_workload\_name](#input\_firewall\_egress\_route\_workload\_name) | Firewall Egress Route Workload Name | `string` | `"firewallegress"` | no |
| <a name="input_firewall_health_state_critical_threshold"></a> [firewall\_health\_state\_critical\_threshold](#input\_firewall\_health\_state\_critical\_threshold) | Firewall health state for critical alert | `string` | `80` | no |
| <a name="input_firewall_health_state_warning_threshold"></a> [firewall\_health\_state\_warning\_threshold](#input\_firewall\_health\_state\_warning\_threshold) | Firewall health state percent for warning alert | `string` | `95` | no |
| <a name="input_firewall_network_rule_collection_name_allow"></a> [firewall\_network\_rule\_collection\_name\_allow](#input\_firewall\_network\_rule\_collection\_name\_allow) | Firewall Network Rule Collection Name Workload Name | `string` | `"allow"` | no |
| <a name="input_firewall_network_rule_collection_priority"></a> [firewall\_network\_rule\_collection\_priority](#input\_firewall\_network\_rule\_collection\_priority) | Priority of network rule collection | `number` | `300` | no |
| <a name="input_firewall_public_ips"></a> [firewall\_public\_ips](#input\_firewall\_public\_ips) | Firewall Public IPs | <pre>map(object({<br>    public_ip_name         = string<br>    private_ip_address     = string<br>    fw_ip_association_name = string<br>  }))</pre> | n/a | yes |
| <a name="input_firewall_snat_port_utilization_percent_critical_threshold"></a> [firewall\_snat\_port\_utilization\_percent\_critical\_threshold](#input\_firewall\_snat\_port\_utilization\_percent\_critical\_threshold) | Firewall SNAT port utilization percent for critical alert | `string` | `95` | no |
| <a name="input_firewall_snat_port_utilization_percent_warning_threshold"></a> [firewall\_snat\_port\_utilization\_percent\_warning\_threshold](#input\_firewall\_snat\_port\_utilization\_percent\_warning\_threshold) | Firewall SNAT port utilization percent for warning alert | `string` | `80` | no |
| <a name="input_firewall_subnet_address_prefix"></a> [firewall\_subnet\_address\_prefix](#input\_firewall\_subnet\_address\_prefix) | Firewall subnet address prefix | `string` | n/a | yes |
| <a name="input_firewall_zones"></a> [firewall\_zones](#input\_firewall\_zones) | The firewall zones | `list(string)` | n/a | yes |
| <a name="input_waf_workload"></a> [waf\_workload](#input\_waf\_workload) | WAF workload application name | `string` | n/a | yes |
| <a name="input_waf_mode"></a> [waf\_mode](#input\_waf\_mode) | WAF mode | `string` | `"Prevention"` | no |
| <a name="input_waf_redirect_url"></a> [waf\_redirect\_uri](#input\_waf\_redirect\_uri) | WAF redirect url | `string` | n/a | no |
| <a name="input_waf_custom_block_response_body_path"></a> [waf\_custom\_block\_response\_body\_path](#input\_waf\_custom\_block\_response\_body\_path) | WAF Custom Block Response Body Path | `string` | n/a | no |
| <a name="input_hub_name"></a> [hub\_name](#input\_hub\_name) | The name of the hub | `string` | `"hub"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region to deploy | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_internet_ingestion_enabled"></a> [log\_analytics\_workspace\_internet\_ingestion\_enabled](#input\_log\_analytics\_workspace\_internet\_ingestion\_enabled) | Should the Log Analytics Workspace support ingestion over the Public Internet? | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_internet_query_enabled"></a> [log\_analytics\_workspace\_internet\_query\_enabled](#input\_log\_analytics\_workspace\_internet\_query\_enabled) | Should the Log Analytics Workspace support querying over the Public Internet? | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_log_retention_in_days"></a> [log\_analytics\_workspace\_log\_retention\_in\_days](#input\_log\_analytics\_workspace\_log\_retention\_in\_days) | The log retention in days | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_sku"></a> [log\_analytics\_workspace\_sku](#input\_log\_analytics\_workspace\_sku) | The sku of the log analytics workspace | `string` | `"PerGB2018"` | no |
| <a name="input_monitoring_alerts_actions_emails_critical"></a> [monitoring\_alerts\_actions\_emails\_critical](#input\_monitoring\_alerts\_actions\_emails\_critical) | List of the email receives for Critical alerts | <pre>list(object({<br>    name                    = string<br>    email_address           = string<br>    use_common_alert_schema = bool<br>  }))</pre> | n/a | yes |
| <a name="input_monitoring_alerts_actions_emails_warning"></a> [monitoring\_alerts\_actions\_emails\_warning](#input\_monitoring\_alerts\_actions\_emails\_warning) | List of the email receives for Warning alerts | <pre>list(object({<br>    name                    = string<br>    email_address           = string<br>    use_common_alert_schema = bool<br>  }))</pre> | n/a | yes |
| <a name="input_padding"></a> [padding](#input\_padding) | Padding for the deployment | `string` | n/a | yes |
| <a name="input_private_endpoint_subnet_address_prefix"></a> [private\_endpoint\_subnet\_address\_prefix](#input\_private\_endpoint\_subnet\_address\_prefix) | Private Endpoint Subnet Address Prefix | `string` | n/a | yes |
| <a name="input_private_endpoint_subnet_workload_name"></a> [private\_endpoint\_subnet\_workload\_name](#input\_private\_endpoint\_subnet\_workload\_name) | Private endpoint subnet workload name | `string` | `"private-endpoint"` | no |
| <a name="input_private_endpoint_subnet_workload_name_ampls"></a> [private\_endpoint\_subnet\_workload\_name\_ampls](#input\_private\_endpoint\_subnet\_workload\_name\_ampls) | AMPLS private endpoint subnet workload name | `string` | `"ampls"` | no |
| <a name="input_private_link_scope_workload_name"></a> [private\_link\_scope\_workload\_name](#input\_private\_link\_scope\_workload\_name) | private link scope workload name | `string` | `"private-la"` | no |
| <a name="input_public_address_prefixes"></a> [public\_address\_prefixes](#input\_public\_address\_prefixes) | Allow IP address list for private resources | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The name of the project | `string` | n/a | yes |
| <a name="input_public_ip_prefix_length"></a> [public\_ip\_prefix\_length](#input\_public\_ip\_prefix\_length) | Public IP Prefix Length | `number` | `30` | no |
| <a name="input_role_definition_name_reader"></a> [role\_definition\_name\_reader](#input\_role\_definition\_name\_reader) | Role definition name reader | `string` | `"Reader"` | no |
| <a name="input_scale_set_agents_subnet_address_prefixes"></a> [scale\_set\_agents\_subnet\_address\_prefixes](#input\_scale\_set\_agents\_subnet\_address\_prefixes) | Scale set agents subnet address prefixes | `list(string)` | n/a | yes |
| <a name="input_shortened_environment"></a> [shortened\_environment](#input\_shortened\_environment) | Shortened version of environment | `string` | n/a | yes |
| <a name="input_shortened_location"></a> [shortened\_location](#input\_shortened\_location) | Shortened version of location | `string` | n/a | yes |
| <a name="input_shortened_padding"></a> [shortened\_padding](#input\_shortened\_padding) | Shortened version of padding | `string` | n/a | yes |
| <a name="input_shortened_project"></a> [shortened\_project](#input\_shortened\_project) | Shortened version of project | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The Azure subscription ID | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure subscription tenant ID | `string` | n/a | yes |
| <a name="input_virtual_network_address_space"></a> [virtual\_network\_address\_space](#input\_virtual\_network\_address\_space) | The CIDR of the Virtual Network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_admin_group_id"></a> [bastion\_admin\_group\_id](#output\_bastion\_admin\_group\_id) | Bastion Admin Group ID |
| <a name="output_bastion_user_group_id"></a> [bastion\_user\_group\_id](#output\_bastion\_user\_group\_id) | Bastion User Group ID |
| <a name="output_firewall_private_ip"></a> [firewall\_private\_ip](#output\_firewall\_private\_ip) | Private IP of the Firewall |
| <a name="output_firewall_resource_id"></a> [firewall\_resource\_id](#output\_firewall\_resource\_id) | Firewall resource ID |
| <a name="output_la_resource_id"></a> [la\_resource\_id](#output\_la\_resource\_id) | Log analytics workspace resource ID |
| <a name="output_vnet_resource_id"></a> [vnet\_resource\_id](#output\_vnet\_resource\_id) | Virtual network resource ID |
