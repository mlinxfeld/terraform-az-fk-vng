# Azure Virtual Network Gateway with Terraform/OpenTofu - Training Examples

This directory contains all progressive examples used with the **terraform-az-fk-vng** module.
The examples are designed as **incremental building blocks**, starting from a minimal gateway stack and focusing on how the VNG composes with the VNet and Public IP modules.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used across Azure networking and infrastructure-as-code learning material.

---

## Example Overview

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Basic VNG** | VNet module, GatewaySubnet, Public IP module, Virtual Network Gateway |

Each example builds on the **concepts** introduced in the previous one, but can be applied independently for learning and experimentation.

---

## How to Use

Each example directory contains:

- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A minimal, runnable architecture

To run an example:

```bash
cd examples/01-basic-vng
tofu init
tofu plan
tofu apply
```

You can apply the example independently. As additional examples are added, follow them in numeric order.

This mirrors real-world gateway design, where the Virtual Network and Public IP are created first and then consumed by the VNG module.

---

## Design Principles

- One example = one architectural goal
- No unused or placeholder resources
- Clear separation of concerns between VNet, Public IP, and VNG
- Examples designed to integrate with other modules such as VNet and Public IP

These examples intentionally avoid:

- Full landing zones
- Opinionated enterprise frameworks
- Hidden dependencies between examples

---

## Related Resources

- [FoggyKitchen Azure VNG Module (terraform-az-fk-vng)](../)
- [FoggyKitchen Azure VNet Module (terraform-az-fk-vnet)](https://github.com/foggykitchen/terraform-az-fk-vnet)
- [FoggyKitchen Azure Public IP Module (terraform-az-fk-public-ip)](https://github.com/foggykitchen/terraform-az-fk-public-ip)
- [FoggyKitchen Azure NAT Gateway Module (terraform-az-fk-natgw)](https://github.com/foggykitchen/terraform-az-fk-natgw)
- [FoggyKitchen Azure Private Endpoint Module (terraform-az-fk-private-endpoint)](https://github.com/foggykitchen/terraform-az-fk-private-endpoint)
- [FoggyKitchen Azure Private DNS Module (terraform-az-fk-private-dns)](https://github.com/foggykitchen/terraform-az-fk-private-dns)
- [FoggyKitchen Azure VNet Peering Module (terraform-az-fk-vnet-peering)](https://github.com/foggykitchen/terraform-az-fk-vnet-peering)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](../LICENSE) for details.

---

© 2026 FoggyKitchen.com - Cloud. Code. Clarity.
