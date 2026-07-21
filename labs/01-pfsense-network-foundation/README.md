# 01 — pfSense Network Foundation

The base infrastructure the rest of the portfolio ladders on: a virtualised
pfSense network with segmented LANs, DHCP, WAN access, and verified Layer-2/3
connectivity.

## Objective
Stand up the pfSense topology, connect clients on each network, and verify
addressing, name resolution, and Internet reachability with packet-level proof.

## What I built
- pfSense firewall/router with a segmented LAN behind it.
- DHCP service handing out the `.10–.100` range.
- Client hosts configured and verified on each network.
- WAN / Internet access through pfSense NAT.

## Verification (offensive/defensive lens)
Captured and filtered traffic in Wireshark to prove the data path end to end:
- **ARP / MAC** — Layer-2 resolution on the local segment.
- **ICMP** — reachability across the topology.
- **TCP / DNS / HTTP** — a full application flow out to the WAN.

Understanding exactly what is on the wire at each layer is the foundation for
every later detection and hardening step.

## Skills & tools
pfSense, DHCP, NAT, Wireshark (ARP/ICMP/TCP/DNS/HTTP), IP addressing & subnetting.

## Artifacts
- `configs/` — pfSense interface/DHCP export
- `diagrams/` — topology
- `evidence/` — Wireshark captures (ARP, ICMP, TCP/DNS/HTTP), WAN access

## Reference
Addresses: [`../../docs/network-topology.md`](../../docs/network-topology.md)
