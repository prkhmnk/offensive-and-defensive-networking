# 05 — LAN Security (VLANs, Port Security, STP)

Layer-2 defensive design in Cisco Packet Tracer: subnetting, VLAN segmentation,
OSPF, and switch-port hardening against MAC/DHCP spoofing and VLAN hopping.

## Objective
Segment Networks A and C into subnets, design a VLAN topology, run OSPF between
the routed segments, and lock down switch ports.

## What I built
- Three subnets per network (with the supporting subnet calculations).
- VLAN design in Packet Tracer with inter-VLAN routing.
- OSPF across the segmented topology.
- **Port Security** (sticky MAC / violation actions) and **STP** on the switches.

## Offensive/defensive lens
Segmentation limits lateral movement and shrinks the blast radius of a
compromise; Port Security and STP defend the data plane against MAC flooding,
rogue devices, and topology attacks.

## Skills & tools
Subnetting, VLANs, inter-VLAN routing, OSPF, Port Security, STP, DHCP snooping,
Cisco IOS CLI, Packet Tracer.

## Artifacts
- `configs/` — Packet Tracer `.pkt` and key `show run` excerpts
- `diagrams/` — VLAN topology
- `evidence/` — VLAN verification, OSPF routes, port-security violation demo

## Reference
Addresses: [`../../docs/network-topology.md`](../../docs/network-topology.md)
