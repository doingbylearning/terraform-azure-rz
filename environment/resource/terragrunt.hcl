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
  
 #Main Resource var's
  subscriptionid                    = "55499760-24b4-466b-bb02-897da98f1ec7"
  resourcegroup_name                = "test-oops-rz-terraform"
  location                          = "North Europe"

 #Network var's
  dnsservers                        = ["8.8.8.8", "8.8.4.4"]
  addressspace_main                 = ["10.16.0.0/16"]
  public_subnet_cidr                = ["10.16.10.0/24", "10.16.11.0/24"]

}