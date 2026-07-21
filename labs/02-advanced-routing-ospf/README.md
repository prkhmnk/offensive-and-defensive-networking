# 02 — Advanced Routing (Static + OSPF)

Made two isolated networks reach each other across a transit network, first with
static routes, then with dynamic OSPF — the routing substrate every later attack
and defense traverses.

## Objective
Enable a host in Network A to reach a host in Network C through transit
Network B, using pfSense gateways, static routing, and OSPF (FRR).

## What I built
- Point-to-point gateways on the `10.120.0.0/24` transit link
  (`routetopf1` / `routetopf2`).
- Static routes between Networks A, B, and C.
- OSPF adjacency between both pfSense routers via the FRR package.
- End-to-end validation: SSH from the Kali attacker to the Windows victim across
  the routed path.

## Offensive/defensive lens
Cross-network reachability is what makes a lateral attack possible — establishing
it here (and proving it with a working SSH session) sets up the firewall (03) and
IDS (04) projects that constrain and detect that same path.

## Skills & tools
pfSense routing, static routes, OSPF / FRR, gateway monitoring, SSH.

## Engineering notes
- WAN on pfSense-2 must be **Static IPv4** before the gateway leaves *Pending*.
- FRR OSPF areas are set in the **Areas** subtab (no "Default Area" field on the
  main tab).

## Artifacts
- `configs/` — gateways, static routes, FRR/OSPF export
- `evidence/` — routing table, OSPF neighbours, successful cross-network SSH

## Reference
Addresses & conventions: [`../../docs/network-topology.md`](../../docs/network-topology.md) ·
[`../../docs/engineering-notes.md`](../../docs/engineering-notes.md)
