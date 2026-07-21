# Network topology & addressing

The single source of truth for every project. Copy values from here.

## Topology
```
Internet
   │
[ pfSense-1 ]  NAT / gateway        LAN = Network C
   │  10.120.0.1 (Network B side)   192.168.120.1
   │
Network B (transit) 10.120.0.0/24
   │
   │  10.120.0.2  WAN (em0)
[ pfSense-2 ]  internal router      LAN (em1) = Network A
   │                                172.16.120.1
Network A 172.16.120.0/24        Network C 192.168.120.0/24
   │                                │
Kali (attacker) 172.16.120.11    Windows 11 (victim/server) 192.168.120.10
```

## Networks
| Role | Network | Mask | Gateway |
| --- | --- | --- | --- |
| Network A (pfSense-2 LAN) | 172.16.120.0 | /24 | 172.16.120.1 |
| Network B (transit) | 10.120.0.0 | /24 | — |
| Network C (pfSense-1 LAN) | 192.168.120.0 | /24 | 192.168.120.1 |

## Transit endpoints
| Device | Interface | Address |
| --- | --- | --- |
| pfSense-1 | Network B side | 10.120.0.1 |
| pfSense-2 | WAN (em0) | 10.120.0.2 (Static IPv4) |

## Hosts
| Host | Role | Address |
| --- | --- | --- |
| pfSense-1 | NAT / Internet gateway (LAN = Net C) | 192.168.120.1 |
| pfSense-2 | Internal router (WAN=Net B, LAN=Net A) | em0 10.120.0.2 / em1 172.16.120.1 |
| Windows 11 | Victim / server (IIS, OpenSSH) | 192.168.120.10 |
| Kali | Attacker | 172.16.120.11 |

DHCP range: `.10 – .100`. Use `/24` throughout.
