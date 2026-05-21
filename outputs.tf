output "gateway_id" {
  description = "Virtual Network Gateway resource ID."
  value       = azurerm_virtual_network_gateway.this.id
}

output "gateway_name" {
  description = "Virtual Network Gateway resource name."
  value       = azurerm_virtual_network_gateway.this.name
}

output "gateway_type" {
  description = "Virtual Network Gateway type."
  value       = azurerm_virtual_network_gateway.this.type
}

output "gateway_sku" {
  description = "Virtual Network Gateway SKU."
  value       = azurerm_virtual_network_gateway.this.sku
}

output "ip_configuration_names" {
  description = "List of IP configuration names used by the gateway."
  value       = [for cfg in var.ip_configurations : cfg.name]
}

output "ip_configuration_subnet_ids" {
  description = "Map of IP configuration name to subnet ID."
  value       = { for cfg in var.ip_configurations : cfg.name => cfg.subnet_id }
}

output "ip_configuration_public_ip_ids" {
  description = "Map of IP configuration name to Public IP ID."
  value       = { for cfg in var.ip_configurations : cfg.name => try(cfg.public_ip_address_id, null) }
}

output "vpn_client_address_space" {
  description = "Configured VPN client address space, if present."
  value       = var.vpn_client_configuration == null ? null : var.vpn_client_configuration.address_space
}
