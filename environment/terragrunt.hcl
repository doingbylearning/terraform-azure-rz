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
    subscription_id                   = "bb201c92-772b-4d50-91cd-871224e1bce6"
    resource_group_name               = "testoopsrz"
    storage_account_name              = "oopsterraformstorage"
    container_name                    = "terraformstate"
    key                               = format("%s/terraform.tfstate", path_relative_to_include())
    
  }
}