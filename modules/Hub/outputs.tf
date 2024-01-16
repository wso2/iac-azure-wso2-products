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

output "firewall_private_ip" {
  value       = module.firewall.firewall_private_ip
  description = "Private IP of the Firewall"
  depends_on  = [module.firewall]
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

output "firewall_public_ip_addresses" {
  value       = module.firewall.firewall_public_ip_addresses
  description = "Public IPs of the Firewall"
  depends_on  = [module.firewall]
}
