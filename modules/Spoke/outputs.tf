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
output "vnet_resource_id" {
  value       = module.spoke-virtual-network.virtual_network_id
  description = "Virtual network resource ID"
  depends_on  = [module.spoke-virtual-network]
}

output "is_fileshare_storage_account_resource_id" {
  value       = module.premium-fileshare-storage-account.storage_account_id
  description = "IS fileshare storage account resource ID"
  depends_on  = [module.premium-fileshare-storage-account]
}

output "bastion_jump_box_resource_id" {
  value       = module.bastion.bastion_vm_id
  description = "Bastion jump box VM resource ID"
  depends_on  = [module.bastion]
}
