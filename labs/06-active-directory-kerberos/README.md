# 06 — Active Directory & Kerberos

Central identity for the network: a Windows domain controller, domain-joined
client, and analysis of the Kerberos authentication that underpins it.

## Objective
Stand up Active Directory in the pfSense environment, join a client, verify
user authentication, and analyse the Kerberos exchange down to the packet.

## What I built
- Domain Controller hosting AD DS, with an OU structure.
- Windows client joined to the domain; regular-user authentication verified.
- Kerberos traffic captured and analysed in Wireshark (AS-REQ/REP, TGS).
- Kerberos configured to authenticate a specific service (IIS Web).

## Offensive/defensive lens
Kerberos authenticates users without sending passwords over the wire and enables
SSO — understanding its ticket flow (KDC → AS → TGS) is the basis for both
securing it and recognising attacks against it.

## Skills & tools
Active Directory (AD DS), Domain Controller, OUs, Kerberos (KDC/AS/TGS), LDAP,
SSO, IIS service auth, Wireshark.

## Artifacts
- `configs/` — AD/OU and service-auth configuration notes
- `evidence/` — domain join, user auth, Kerberos in Wireshark, IIS Kerberos

## Reference
Addresses: [`../../docs/network-topology.md`](../../docs/network-topology.md)
