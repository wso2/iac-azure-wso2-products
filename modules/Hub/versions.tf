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

terraform {
  required_version = "= 0.14.10"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.52.0"
    }
    azuread = "= 2.14.0"
  }
}
