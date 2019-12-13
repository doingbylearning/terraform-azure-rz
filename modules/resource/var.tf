variable "subscriptionid" {
    description                     = "ID of the used Subscription"
    type                            = string
}

variable "resourcegroup_name" {
    description                     = "Name of the Resource Group"
    type                            = string
}

variable "location" {
  description                       = "globally used location to deploy to"
  type                              = string
  }

variable "dnsservers" {
    description                     = "Used DNS Servers"
    type                            = list(string)
}

variable "addressspace_main" {
    description                     = "Main Address Space CIDR used"
    type                            = list  
}

variable "public_subnet_cidr" {
    description                     = "Public Subnet CIDRs used"
    type                            = list(string)
}
