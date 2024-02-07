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

## WAF policy
module "fdwafpolicy" {
  source              = "git::https://github.com/wso2/azure-terraform-modules.git//modules/azurerm/FrontDoor-WAF?ref=v0.5.0"
  tags                = local.default_tags
  resource_group_name = module.hub-resource-group.resource_group_name

  depends_on = [
    module.hub-resource-group
  ]
  
  front_door_waf_object = {
    fdwaf_is = {
      front_door_waf_policy_name        = join("", [var.project, var.hub_name, var.waf_workload, var.environment, var.padding])
      enabled                           = true
      mode                              = var.waf_mode
      redirect_url                      = var.waf_redirect_url
      custom_block_response_status_code = null
      custom_block_response_body        = var.waf_custom_block_response_body_path
      custom_rule                       = []
      managed_rule = [
        {
          type      = "Microsoft_DefaultRuleSet",
          version   = "1.1",
          exclusion = [],
          override  = []
        },
        {
          type      = "Microsoft_BotManagerRuleSet",
          version   = "1.0",
          exclusion = [],
          override  = []
        }
      ]
    }
  }
}
