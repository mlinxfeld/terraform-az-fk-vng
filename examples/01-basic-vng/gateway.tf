module "vng" {
  source = "../.."

  name                = var.gateway_name
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  type = "Vpn"
  sku  = "VpnGw1"

  ip_configurations = [
    {
      name                 = "vng-ipcfg-1"
      subnet_id            = module.vnet.subnet_ids["GatewaySubnet"]
      public_ip_address_id = module.public_ip.id
    }
  ]

  tags = {
    example = "basic-vng"
  }
}
