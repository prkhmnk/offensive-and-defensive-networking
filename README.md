# Offensive & Defensive Networking

[![ci](https://github.com/prkhmnk/offensive-and-defensive-networking/actions/workflows/ci.yml/badge.svg)](https://github.com/prkhmnk/offensive-and-defensive-networking/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A segmented enterprise network built, attacked, and then defended — worked
bottom-up on a virtualised **pfSense / Kali / Windows** lab. Starting from a
bare two-firewall topology, each project adds a layer: routing, stateful
firewalling and NAT, intrusion detection/prevention, Layer-2 hardening, and
Active-Directory authentication. Every project builds on the previous one and
runs on the **same fixed network configuration**.

> Developed as coursework for **ITSC-206 (Offensive and Defensive Networking)**
> at SAIT, and structured as an engineering portfolio — each lab is a
> self-contained project with a technical write-up, the artifacts that prove it
> (configs, rules, diagrams, capture evidence), and reproducible environment
> notes.
>
> **Scope note.** Offensive techniques (brute force, spoofing, recon) are
> demonstrated only to validate the matching defensive control on an isolated,
> self-owned lab network. Nothing here targets third-party systems.

---

## Skills demonstrated

- **Routing & segmentation** — pfSense multi-network design, static routing,
  OSPF via FRR, point-to-point transit links
- **Perimeter security** — stateful firewall rule design (least-privilege
  Pass/Block, top-down ordering), NAT and port forwarding
- **IDS / IPS** — Snort rule authoring, `detection_filter` rate thresholds,
  spoofing detection, port-knock (`knockd`) detection, Suricata familiarity
- **Offensive validation** — SSH brute force (Hydra) and recon executed, then
  mitigated and detected — attack → block → alert
- **LAN hardening** — VLAN segmentation, Port Security, STP, DHCP snooping
  (Cisco Packet Tracer)
- **Identity & authentication** — Active Directory (AD DS), domain join,
  Kerberos (KDC/AS/TGS), LDAP, per-service auth (IIS)
- **Traffic analysis** — Wireshark capture/filtering of ARP, ICMP, TCP, DNS,
  HTTP, and Kerberos exchanges
- **Tooling** — pfSense, Kali Linux, Snort/Suricata, Cisco Packet Tracer,
  Wireshark, Windows Server / AD, Hydra, `knockd`

---

## Projects

| #  | Project | What it demonstrates | Status |
| --- | --- | --- | --- |
| 01 | [pfSense network foundation](labs/01-pfsense-network-foundation) | Multi-network topology, DHCP, WAN access, packet capture | Done |
| 02 | [Advanced routing (static + OSPF)](labs/02-advanced-routing-ospf) | Cross-network reachability, FRR OSPF, gateways | Done |
| 03 | [Stateful firewall & NAT](labs/03-stateful-firewall-nat) | Least-privilege rules, port forwarding, exposing IIS/SSH | Done |
| 04 | [IDS / IPS with Snort](labs/04-ids-ips-snort) | Custom detection rules, brute-force & spoofing detection | Done |
| 05 | [LAN security](labs/05-lan-security) | VLANs, subnetting, Port Security, STP (Packet Tracer) | Done |
| 06 | [Active Directory & Kerberos](labs/06-active-directory-kerberos) | Domain controller, domain join, Kerberos analysis | Done |
| 07 | [VPN](labs/07-vpn) | Secure site connectivity (topology + crypto) | Planned |

---

## The network

Every project runs on one fixed topology and address plan — the single source of
truth is [`docs/network-topology.md`](docs/network-topology.md).

```
Internet ── pfSense-1 (NAT) ──[ Network C 192.168.120.0/24 ]── Windows 11 (victim/server)
                 │
        Network B 10.120.0.0/24  (transit)
                 │
            pfSense-2 (router) ──[ Network A 172.16.120.0/24 ]── Kali (attacker)
```

Engineering conventions and non-obvious lessons (e.g. Snort `$HOME_NET` scope
across routed networks) are documented in
[`docs/engineering-notes.md`](docs/engineering-notes.md).

---

## Getting started

This is a VM-based lab, so "building" means reproducing the environment and
validating the committed artifacts.

```bash
# Reproduce the lab environment (VM inventory, LAN segments, addressing)
see docs/lab-environment.md

# Validate committed Snort rules and helper scripts
make validate
```

See [`env/README.md`](env/README.md) for the full VM/topology specification.

---

## Repository layout

```
labs/NN-name/         # one self-contained project each
  README.md           #   technical write-up
  configs/            #   pfSense / switch / rule exports
  diagrams/           #   topology & design diagrams
  evidence/           #   capture screenshots proving the result
docs/                 # topology, environment, engineering notes
env/                  # reproducible lab environment spec
scripts/              # validation / demo helpers
```

---

## Author

**Oleh Parkhomenko** · [github.com/prkhmnk](https://github.com/prkhmnk)

## License

Original work (write-ups, rules, scripts, diagrams) under the [MIT License](LICENSE).
Course assignment specifications are the property of SAIT and are **not**
redistributed here.
