locals {
  ip_configuration_public_ip_ids = [
    for cfg in var.ip_configurations : cfg.public_ip_address_id
  ]
}

resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  type                                  = var.type
  sku                                   = var.sku
  vpn_type                              = var.type == "Vpn" ? var.vpn_type : null
  active_active                         = var.active_active
  bgp_enabled                           = var.bgp_enabled
  default_local_network_gateway_id      = var.default_local_network_gateway_id
  edge_zone                             = var.edge_zone
  generation                            = var.generation
  private_ip_address_enabled            = var.private_ip_address_enabled
  bgp_route_translation_for_nat_enabled = var.bgp_route_translation_for_nat_enabled
  dns_forwarding_enabled                = var.dns_forwarding_enabled
  ip_sec_replay_protection_enabled      = var.ip_sec_replay_protection_enabled
  remote_vnet_traffic_enabled           = var.remote_vnet_traffic_enabled
  virtual_wan_traffic_enabled           = var.virtual_wan_traffic_enabled

  dynamic "ip_configuration" {
    for_each = var.ip_configurations
    content {
      name                          = ip_configuration.value.name
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = ip_configuration.value.subnet_id
      public_ip_address_id          = try(ip_configuration.value.public_ip_address_id, null)
    }
  }

  dynamic "bgp_settings" {
    for_each = var.bgp_settings == null ? [] : [var.bgp_settings]
    content {
      asn         = try(bgp_settings.value.asn, null)
      peer_weight = try(bgp_settings.value.peer_weight, null)

      dynamic "peering_addresses" {
        for_each = try(bgp_settings.value.peering_addresses, [])
        content {
          ip_configuration_name = try(peering_addresses.value.ip_configuration_name, null)
          apipa_addresses       = try(peering_addresses.value.apipa_addresses, [])
        }
      }
    }
  }

  dynamic "custom_route" {
    for_each = var.custom_route == null ? [] : [var.custom_route]
    content {
      address_prefixes = custom_route.value.address_prefixes
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_client_configuration == null ? [] : [var.vpn_client_configuration]
    content {
      address_space         = vpn_client_configuration.value.address_space
      aad_tenant            = try(vpn_client_configuration.value.aad_tenant, null)
      aad_audience          = try(vpn_client_configuration.value.aad_audience, null)
      aad_issuer            = try(vpn_client_configuration.value.aad_issuer, null)
      vpn_client_protocols  = try(vpn_client_configuration.value.vpn_client_protocols, [])
      vpn_auth_types        = try(vpn_client_configuration.value.vpn_auth_types, [])
      radius_server_address = try(vpn_client_configuration.value.radius_server_address, null)
      radius_server_secret  = try(vpn_client_configuration.value.radius_server_secret, null)

      dynamic "ipsec_policy" {
        for_each = try(vpn_client_configuration.value.ipsec_policy, null) == null ? [] : [vpn_client_configuration.value.ipsec_policy]
        content {
          dh_group                  = ipsec_policy.value.dh_group
          ike_encryption            = ipsec_policy.value.ike_encryption
          ike_integrity             = ipsec_policy.value.ike_integrity
          ipsec_encryption          = ipsec_policy.value.ipsec_encryption
          ipsec_integrity           = ipsec_policy.value.ipsec_integrity
          pfs_group                 = ipsec_policy.value.pfs_group
          sa_lifetime_in_seconds    = ipsec_policy.value.sa_lifetime_in_seconds
          sa_data_size_in_kilobytes = ipsec_policy.value.sa_data_size_in_kilobytes
        }
      }

      dynamic "root_certificate" {
        for_each = try(vpn_client_configuration.value.root_certificates, [])
        content {
          name             = root_certificate.value.name
          public_cert_data = root_certificate.value.public_cert_data
        }
      }

      dynamic "revoked_certificate" {
        for_each = try(vpn_client_configuration.value.revoked_certificates, [])
        content {
          name       = revoked_certificate.value.name
          thumbprint = revoked_certificate.value.thumbprint
        }
      }

      dynamic "radius_server" {
        for_each = try(vpn_client_configuration.value.radius_servers, [])
        content {
          address = radius_server.value.address
          secret  = radius_server.value.secret
          score   = radius_server.value.score
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = try(timeouts.value.create, null)
      read   = try(timeouts.value.read, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.active_active ? length(var.ip_configurations) >= 2 : true
      error_message = "active_active=true requires at least two ip_configurations."
    }

    precondition {
      condition     = var.active_active || length(var.ip_configurations) == 1
      error_message = "More than one ip_configuration requires active_active=true."
    }

    precondition {
      condition = var.type != "Vpn" || alltrue([
        for ip_configuration_id in local.ip_configuration_public_ip_ids : ip_configuration_id != null
      ])
      error_message = "Vpn gateways require public_ip_address_id in every ip_configuration."
    }

    precondition {
      condition = var.type != "ExpressRoute" || alltrue([
        for ip_configuration_id in local.ip_configuration_public_ip_ids : ip_configuration_id == null
      ])
      error_message = "ExpressRoute gateways must not set public_ip_address_id in ip_configuration blocks."
    }

    precondition {
      condition     = var.bgp_settings == null || var.bgp_enabled
      error_message = "bgp_settings can only be used when bgp_enabled=true."
    }

    precondition {
      condition     = var.type != "ExpressRoute" || var.vpn_client_configuration == null
      error_message = "vpn_client_configuration is only valid for Vpn gateways."
    }
  }
}
