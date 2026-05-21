output "resource_group_name" {
  value = azurerm_resource_group.foggykitchen_rg.name
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "gateway_subnet_id" {
  value = module.vnet.subnet_ids["GatewaySubnet"]
}

output "public_ip_id" {
  value = module.public_ip.id
}

output "gateway_id" {
  value = module.vng.gateway_id
}
