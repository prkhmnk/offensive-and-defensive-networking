# 03 — Stateful Firewall & NAT

Turned open reachability into controlled access: least-privilege firewall rules
plus NAT port forwarding to expose only the services that should be reachable.

## Objective
Publish a Windows web (IIS) and SSH service to remote networks through explicit,
minimal firewall rules and a NAT port forward — and block everything else.

## What I built
- Windows 11 configured as an IIS web server; verified `sshd` running.
- Windows Defender + pfSense rules allowing only HTTP and SSH inbound.
- Explicit Pass/Block rules, ordered top-to-bottom (first match wins).
- Firewall NAT **port forwarding** to the internal service host.

## Offensive/defensive lens
This is the perimeter control plane. The same SSH service exposed here becomes
the target of the brute-force attack detected in project 04 — least-privilege
rules shrink the attack surface to exactly one intended port.

## Skills & tools
pfSense stateful firewall, rule ordering, NAT / port forwarding, Windows Defender
Firewall, IIS, OpenSSH.

## Engineering notes
- Rules are evaluated top-to-bottom — order is a security control, not cosmetics.
- NAT Outbound is **Automatic** by instructor convention; the empty Automatic
  table on pfSense-2 is expected (no direct uplink).

## Artifacts
- `configs/` — firewall rule + NAT port-forward exports
- `evidence/` — rule tables, local/remote web access, SSH, port-forward test

## Reference
Addresses: [`../../docs/network-topology.md`](../../docs/network-topology.md)
