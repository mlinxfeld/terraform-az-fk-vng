variable "resource_group_name" {
  type    = string
  default = "fk-vng-demo-rg"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "vnet_name" {
  type    = string
  default = "fk-vnet-vng"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.40.0.0/16"]
}

variable "gateway_subnet_prefixes" {
  type    = list(string)
  default = ["10.40.255.0/27"]
}

variable "gateway_name" {
  type    = string
  default = "fk-vng-demo"
}

variable "public_ip_name" {
  type    = string
  default = "fk-vng-pip"
}

variable "tags" {
  type = map(string)
  default = {
    project = "foggykitchen"
    env     = "dev"
    example = "01-basic-vng"
  }
}
