# 04 — IDS / IPS with Snort

Added detection to the perimeter: custom Snort rules that catch a brute-force
attack and spoofing, plus port-knock detection — the "alert" half of
attack → block → alert.

## Objective
Deploy Snort on pfSense and author detection rules for real attacks against the
lab, including a rate-based SSH brute-force signature and anti-spoofing rules.

## What I built
- Snort installed and configured on the pfSense-2 LAN interface.
- A custom rule (local SID space, `1000000+`) detecting SSH brute force with a
  `detection_filter` threshold (rate over a time window).
- Rules to detect/prevent spoofing.
- Explored pre-defined rule sets; configured `knockd` port knocking and wrote a
  rule to detect the knock sequence.

## Offensive/defensive lens
Ran the attack (Hydra SSH brute force, Kali → Windows) and confirmed the rule
fires, closing the loop from project 02 (reachability) and 03 (block) to
detection here.

## Key engineering lesson
On pfSense-2, **`$HOME_NET` covers only the local LAN (Network A)** — it does
**not** include the remote victim network (`192.168.120.0/24`). A rule targeting
the victim must use the **literal destination IP** (`192.168.120.10`); using
`$HOME_NET` silently never matches. This one detail is the difference between a
rule that looks right and a rule that actually alerts.

## Skills & tools
Snort rule syntax, `detection_filter`, IDS/IPS deployment, Suricata awareness,
Hydra (attack validation), `knockd`.

## Artifacts
- `configs/local.rules` — sample custom detection rule (replace with your exact rule)
- `evidence/` — Snort alerts firing, spoofing detection, knock detection

## Reference
Addresses & the `$HOME_NET` note: [`../../docs/engineering-notes.md`](../../docs/engineering-notes.md)
