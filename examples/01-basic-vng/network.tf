module "vnet" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-vnet.git?ref=v0.1.1"

  name                = var.vnet_name
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  address_space = var.vnet_address_space

  subnets = {
    GatewaySubnet = {
      address_prefixes = var.gateway_subnet_prefixes
    }
  }

  tags = var.tags
}

module "public_ip" {
  source = "git::https://github.com/mlinxfeld/terraform-az-fk-public-ip.git?ref=v1.0.0"

  name                = var.public_ip_name
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = var.tags
}
