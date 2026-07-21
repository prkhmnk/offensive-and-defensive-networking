# Reproducing the lab environment

The lab runs under VMware with three isolated LAN Segments and six VMs.

## VMs
| VM | Role |
| --- | --- |
| pfSense-1 | NAT / Internet gateway |
| pfSense-2 | Internal router / firewall / IDS |
| Kali Linux (×2) | Attacker / tooling |
| Linux Mint | Client |
| Windows 11 | Victim / server (IIS, OpenSSH, later AD client) |

## VMware LAN Segments
Segments are named by network (not by VMnet number, not by lab number):

| Segment | Network |
| --- | --- |
| `LAN_A` | 172.16.120.0/24 |
| `LAN_B` | 10.120.0.0/24 (transit) |
| `LAN_C` | 192.168.120.0/24 |

## Interface map (pfSense-2)
| Interface | Name | Network |
| --- | --- | --- |
| em0 | WAN | Network B (10.120.0.2, Static IPv4) |
| em1 | LAN | Network A (172.16.120.1) |

pfSense-2 has only WAN and LAN — no OPT1.

## Bring-up order
1. pfSense-1 (WAN → Internet, LAN → Network C, NAT).
2. pfSense-2 (WAN → Network B static, LAN → Network A).
3. Gateways + routing (project 02), then per-project services.
