terraform {
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = [
      "-lock-timeout=60m"
    ]
  }
}

remote_state {
  backend = "azurerm"
  config = {
    resource_group_name               = var.resourcegroup_name
    storage_account_name              = "storage${var-resourcegroup_name}"
    container_name                    = "terraform_state"
    key                               = format("%s/terraform.tfstate", path_relative_top_include())
  }
}