include {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//modules/resource"
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = [
      "-lock-timeout=60m"
    ]
  }
}

inputs = {
  subscriptionid                    = "55499760-24b4-466b-bb02-897da98f1ec7"
  resourcegroup_name                = "test-oops-rz-terraform"
  location                          = "North Europe"
}