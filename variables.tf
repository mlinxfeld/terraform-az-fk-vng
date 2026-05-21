variable "name" {
  description = "Name of the Virtual Network Gateway."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the gateway will be created."
  type        = string
}

variable "location" {
  description = "Azure region for the Virtual Network Gateway."
  type        = string
}

variable "type" {
  description = "Gateway type."
  type        = string
  default     = "Vpn"

  validation {
    condition     = contains(["Vpn", "ExpressRoute"], var.type)
    error_message = "type must be either 'Vpn' or 'ExpressRoute'."
  }
}

variable "sku" {
  description = "Gateway SKU."
  type        = string
}

variable "vpn_type" {
  description = "VPN routing type."
  type        = string
  default     = "RouteBased"

  validation {
    condition     = contains(["RouteBased", "PolicyBased"], var.vpn_type)
    error_message = "vpn_type must be either 'RouteBased' or 'PolicyBased'."
  }
}

variable "active_active" {
  description = "Whether the gateway should use active-active mode."
  type        = bool
  default     = false
}

variable "bgp_enabled" {
  description = "Whether BGP is enabled."
  type        = bool
  default     = false
}

variable "default_local_network_gateway_id" {
  description = "Optional local network gateway ID used for forced tunneling."
  type        = string
  default     = null
}

variable "edge_zone" {
  description = "Optional Azure Edge Zone."
  type        = string
  default     = null
}

variable "generation" {
  description = "Gateway generation."
  type        = string
  default     = null

  validation {
    condition     = var.generation == null || contains(["Generation1", "Generation2", "None"], var.generation)
    error_message = "generation must be one of 'Generation1', 'Generation2', 'None', or null."
  }
}

variable "private_ip_address_enabled" {
  description = "Whether private IP is enabled on the gateway."
  type        = bool
  default     = false
}

variable "bgp_route_translation_for_nat_enabled" {
  description = "Whether BGP route translation for NAT is enabled."
  type        = bool
  default     = false
}

variable "dns_forwarding_enabled" {
  description = "Whether DNS forwarding is enabled."
  type        = bool
  default     = false
}

variable "ip_sec_replay_protection_enabled" {
  description = "Whether IPsec replay protection is enabled."
  type        = bool
  default     = true
}

variable "remote_vnet_traffic_enabled" {
  description = "Whether the gateway accepts traffic from other Azure Virtual Networks."
  type        = bool
  default     = false
}

variable "virtual_wan_traffic_enabled" {
  description = "Whether the gateway accepts traffic from remote Virtual WAN networks."
  type        = bool
  default     = false
}

variable "ip_configurations" {
  description = "List of gateway IP configurations. Provide one entry for active-standby and up to three for active-active."
  type = list(object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = optional(string)
  }))

  validation {
    condition     = length(var.ip_configurations) >= 1 && length(var.ip_configurations) <= 3
    error_message = "ip_configurations must contain between 1 and 3 entries."
  }

  validation {
    condition     = length(distinct([for cfg in var.ip_configurations : cfg.name])) == length(var.ip_configurations)
    error_message = "ip_configurations names must be unique."
  }
}

variable "bgp_settings" {
  description = "Optional BGP settings block."
  type = object({
    asn         = optional(number)
    peer_weight = optional(number)
    peering_addresses = optional(list(object({
      ip_configuration_name = optional(string)
      apipa_addresses       = optional(list(string), [])
    })), [])
  })
  default = null
}

variable "custom_route" {
  description = "Optional custom route block."
  type = object({
    address_prefixes = list(string)
  })
  default = null
}

variable "vpn_client_configuration" {
  description = "Optional point-to-site VPN client configuration."
  type = object({
    address_space         = list(string)
    aad_tenant            = optional(string)
    aad_audience          = optional(string)
    aad_issuer            = optional(string)
    vpn_client_protocols  = optional(list(string), [])
    vpn_auth_types        = optional(list(string), [])
    radius_server_address = optional(string)
    radius_server_secret  = optional(string)
    ipsec_policy = optional(object({
      dh_group                  = string
      ike_encryption            = string
      ike_integrity             = string
      ipsec_encryption          = string
      ipsec_integrity           = string
      pfs_group                 = string
      sa_lifetime_in_seconds    = number
      sa_data_size_in_kilobytes = number
    }))
    root_certificates = optional(list(object({
      name             = string
      public_cert_data = string
    })), [])
    revoked_certificates = optional(list(object({
      name       = string
      thumbprint = string
    })), [])
    radius_servers = optional(list(object({
      address = string
      secret  = string
      score   = number
    })), [])
  })
  default = null
}

variable "timeouts" {
  description = "Optional custom timeouts for the gateway."
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
