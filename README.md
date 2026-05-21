# terraform-az-fk-vng

This repository contains a reusable **Terraform / OpenTofu module** for deploying an **Azure Virtual Network Gateway (VNG)** in a clean, explicit, and composable way.

It follows the same learning-first style as the `terraform-az-fk-vnet` module, but focuses on the gateway layer that sits on top of an existing network.

---

## Purpose

The goal of this module is to provide a small, practical building block for Azure connectivity:

- Create one Azure Virtual Network Gateway
- Support VPN and ExpressRoute gateway types
- Support single or active-active IP configurations
- Support optional BGP, custom routes, and P2S VPN client settings

The module intentionally does **not** create:

- Virtual Networks
- Gateway subnets
- Public IPs
- Local Network Gateways
- VPN connections

Those resources are best managed separately and passed into this module as inputs.

---

## What the module does

The module creates:

- one `azurerm_virtual_network_gateway`
- optional BGP configuration
- optional custom routes
- optional VPN client configuration

The module expects the consuming configuration to provide:

- a `GatewaySubnet`
- one or more Public IP IDs for VPN gateways
- no Public IP for ExpressRoute gateways

---

## Repository Structure

```bash
terraform-az-fk-vng/
├── examples/
│   └── 01-basic-vng/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

---

## Example Usage

```hcl
module "vng" {
  source = "git::https://github.com/mlinxfeld/terraform-az-fk-vng.git?ref=v0.2.0"

  name                = "fk-vng-demo"
  location            = "westeurope"
  resource_group_name = "rg-fk-demo"

  type = "Vpn"
  sku  = "VpnGw1"

  ip_configurations = [
    {
      name                 = "vng-ipcfg-1"
      subnet_id            = azurerm_subnet.gateway.id
      public_ip_address_id  = azurerm_public_ip.vng.id
    }
  ]

  tags = {
    project = "foggykitchen"
    env     = "dev"
  }
}
```

---

## Inputs

| Variable | Required | Description |
|------|------|-------------|
| `name` | ✅ | Virtual Network Gateway name |
| `resource_group_name` | ✅ | Resource group name |
| `location` | ✅ | Azure region |
| `type` | ❌ | Gateway type (`Vpn` or `ExpressRoute`) |
| `sku` | ✅ | Gateway SKU |
| `vpn_type` | ❌ | VPN routing type |
| `active_active` | ❌ | Active-active mode |
| `bgp_enabled` | ❌ | Enable BGP |
| `default_local_network_gateway_id` | ❌ | Forced tunneling target |
| `edge_zone` | ❌ | Optional Azure Edge Zone |
| `generation` | ❌ | Gateway generation |
| `private_ip_address_enabled` | ❌ | Enable private IP |
| `bgp_route_translation_for_nat_enabled` | ❌ | Enable BGP NAT translation |
| `dns_forwarding_enabled` | ❌ | Enable DNS forwarding |
| `ip_sec_replay_protection_enabled` | ❌ | Enable IPsec replay protection |
| `remote_vnet_traffic_enabled` | ❌ | Allow remote VNet traffic |
| `virtual_wan_traffic_enabled` | ❌ | Allow Virtual WAN traffic |
| `ip_configurations` | ✅ | Gateway IP configuration list |
| `bgp_settings` | ❌ | Optional BGP settings block |
| `custom_route` | ❌ | Optional custom routes block |
| `vpn_client_configuration` | ❌ | Optional P2S VPN client configuration |
| `timeouts` | ❌ | Optional custom timeouts |
| `tags` | ❌ | Resource tags |

### IP configuration schema

```hcl
ip_configurations = list(object({
  name                 = string
  subnet_id            = string
  public_ip_address_id = optional(string)
}))
```

### VPN client configuration schema

```hcl
vpn_client_configuration = object({
  address_space        = list(string)
  aad_tenant           = optional(string)
  aad_audience         = optional(string)
  aad_issuer           = optional(string)
  vpn_client_protocols = optional(list(string), [])
  vpn_auth_types       = optional(list(string), [])
  radius_server_address = optional(string)
  radius_server_secret  = optional(string)
  ipsec_policy = optional(object({
    dh_group                 = string
    ike_encryption           = string
    ike_integrity            = string
    ipsec_encryption         = string
    ipsec_integrity          = string
    pfs_group                = string
    sa_lifetime_in_seconds   = number
    sa_data_size_in_kilobytes = number
  }))
  root_certificates = optional(list(object({
    name             = string
    public_cert_data  = string
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
```

---

## Outputs

| Output | Description |
|------|-------------|
| `gateway_id` | Virtual Network Gateway ID |
| `gateway_name` | Virtual Network Gateway name |
| `gateway_type` | Virtual Network Gateway type |
| `gateway_sku` | Virtual Network Gateway SKU |
| `ip_configuration_names` | Gateway IP configuration names |
| `ip_configuration_subnet_ids` | Map of configuration name to subnet ID |
| `ip_configuration_public_ip_ids` | Map of configuration name to Public IP ID |
| `vpn_client_address_space` | VPN client address space, if configured |

---

## Design Notes

- The gateway module is intentionally separate from VNet and Public IP modules.
- The consuming stack owns network layout and address planning.
- This keeps the gateway module reusable across VPN and ExpressRoute scenarios.

---

## Related Modules

- [terraform-az-fk-vnet](https://github.com/mlinxfeld/terraform-az-fk-vnet)
- [terraform-az-fk-public-ip](https://github.com/mlinxfeld/terraform-az-fk-public-ip)
- [terraform-az-fk-natgw](https://github.com/mlinxfeld/terraform-az-fk-natgw)
- [terraform-az-fk-private-endpoint](https://github.com/mlinxfeld/terraform-az-fk-private-endpoint)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See `LICENSE` for details.
