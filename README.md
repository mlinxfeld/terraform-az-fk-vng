# terraform-az-fk-vng

This repository contains a reusable **Terraform/OpenTofu module** for deploying **Azure Virtual Network Gateway (VNG)** resources for **VPN** and **ExpressRoute** connectivity scenarios.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and serves as the strategic Azure gateway building block for hybrid, VPN, and private interconnect network designs.

---

## 🎯 Purpose

The goal of this module is to provide a **clean, composable, and educational reference implementation** for Azure gateway-based connectivity:

- Focused on **Azure Virtual Network Gateway resources**
- No hidden VNet, GatewaySubnet, or Public IP creation
- Designed to be composed with **terraform-az-fk-vnet**, **terraform-az-fk-public-ip**, and future Azure connectivity modules

This is **not** a full landing zone replacement. It is a **connectivity foundation module** intended for learning, reuse, and composition.

---

## ✨ What the module does

The module creates:

- Azure Virtual Network Gateway
- Optional BGP configuration
- Optional custom routes
- Optional VPN client configuration

The module intentionally does **not** create:

- Virtual Networks
- Gateway subnets
- Public IPs
- Local Network Gateways
- VPN connections

Each of those concerns belongs in its own dedicated module or composition layer.

---

## 📂 Repository Structure

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

All examples are runnable and demonstrate how gateway-based connectivity composes with reusable Azure networking foundations.

---

## 🚀 Example Usage

```hcl
module "vng" {
  source = "git::https://github.com/mlinxfeld/terraform-az-fk-vng.git?ref=v0.2.1"

  name                = "fk-vng-demo"
  location            = "westeurope"
  resource_group_name = "rg-fk-demo"

  type = "Vpn"
  sku  = "VpnGw1"

  ip_configurations = [
    {
      name                 = "vng-ipcfg-1"
      subnet_id            = azurerm_subnet.gateway.id
      public_ip_address_id = azurerm_public_ip.vng.id
    }
  ]

  tags = {
    project = "foggykitchen"
    env     = "dev"
  }
}
```

---

## ⚙️ Module Inputs

### Core inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `name` | `string` | ✅ | Virtual Network Gateway name |
| `resource_group_name` | `string` | ✅ | Resource group name |
| `location` | `string` | ✅ | Azure region |
| `type` | `string` | ❌ | Gateway type (`Vpn` or `ExpressRoute`) |
| `sku` | `string` | ✅ | Gateway SKU |
| `vpn_type` | `string` | ❌ | VPN routing type |
| `active_active` | `bool` | ❌ | Active-active mode |
| `bgp_enabled` | `bool` | ❌ | Enable BGP |
| `default_local_network_gateway_id` | `string` | ❌ | Local Network Gateway ID used for forced tunneling |
| `edge_zone` | `string` | ❌ | Optional Azure Edge Zone |
| `generation` | `string` | ❌ | Gateway generation |
| `private_ip_address_enabled` | `bool` | ❌ | Enable private IP |
| `bgp_route_translation_for_nat_enabled` | `bool` | ❌ | Enable BGP NAT translation |
| `dns_forwarding_enabled` | `bool` | ❌ | Enable DNS forwarding |
| `ip_sec_replay_protection_enabled` | `bool` | ❌ | Enable IPsec replay protection |
| `remote_vnet_traffic_enabled` | `bool` | ❌ | Allow remote VNet traffic |
| `virtual_wan_traffic_enabled` | `bool` | ❌ | Allow Virtual WAN traffic |
| `ip_configurations` | `list(object)` | ✅ | Gateway IP configuration list |
| `bgp_settings` | `object` | ❌ | Optional BGP settings block |
| `custom_route` | `object` | ❌ | Optional custom routes block |
| `vpn_client_configuration` | `object` | ❌ | Optional P2S VPN client configuration |
| `timeouts` | `object` | ❌ | Optional custom timeouts |
| `tags` | `map(string)` | ❌ | Resource tags |

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
```

---

## 📤 Outputs

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

## 🧠 Design Philosophy

- Explicit over implicit
- Small modules over monoliths
- Gateway connectivity separated from VNet and Public IP foundations
- Optimized for **learning, reuse, and composition**

This makes the module useful for:

- Azure VPN gateway foundations
- Azure ExpressRoute gateway foundations
- Hybrid and multicloud connectivity building blocks
- Progressive evolution beyond simple VNet-only designs

---

## 📌 Notes

- This module supports both `Vpn` and `ExpressRoute` gateway types
- Public IPs should be modeled explicitly and passed in for VPN gateways
- VNet, GatewaySubnet, and connection objects should remain modeled separately

---

## 🌐 Learn More

Visit [FoggyKitchen.com](https://foggykitchen.com/) for Azure, multicloud, and Terraform/OpenTofu learning resources.

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](LICENSE) for details.
