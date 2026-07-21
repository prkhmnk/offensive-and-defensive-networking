# Engineering notes & lessons

Non-obvious things learned building this, kept so they are not re-learned the
hard way.

## Addressing
- Use `/24` everywhere. Any `/25` in a handout is a typo.

## pfSense-2
- Interfaces are **WAN (em0)** and **LAN (em1)** only — no OPT1.
- WAN must be **Static IPv4** before its gateway leaves *Pending*.

## Routing / OSPF
- Gateway naming convention: `routetopf1` / `routetopf2`.
- FRR OSPF areas live in the **Areas** subtab — there is no "Default Area" field
  on the main OSPF tab.
- Firewall rules are matched **top-to-bottom**; ordering is a control.

## NAT Outbound
- **Automatic** by convention; on pfSense-2 the empty Automatic table is normal
  (no direct uplink). Hybrid is the documented alternative.

## Snort (the important one)
- `$HOME_NET` on pfSense-2 covers **only its own LAN (Network A)**. It does
  **not** include remote routed networks such as `192.168.120.0/24`.
- Rules targeting a remote host must use the **literal IP**, never `$HOME_NET`,
  or they silently never match.
- Custom local rules: SID `1000000+`, `detection_filter` for rate thresholds.
