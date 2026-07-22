# Install and Configure Windows Server 2025 – Active Directory

## Overview

In this part of the lab, a Windows Server 2025 virtual machine was prepared and configured as the first Active Directory Domain Controller. The server was installed in VMware Workstation Pro with TPM 2.0 and Secure Boot enabled, connected to the internal lab network, and configured with a static IPv4 address. Active Directory Domain Services (AD DS) and DNS Server roles were installed, and the server was promoted to the first Domain Controller of a new forest and its root domain. The Domain Controller configuration was then verified by creating organizational units (OUs) and user accounts, verifying Active Directory and DNS settings, configuring a reverse lookup zone, and validating the domain services using PowerShell cmdlets.

## Virtual Machine Configuration

| Setting | Value |
|---------|-------|
| Hypervisor | VMware Workstation Pro |
| Operating System | Windows Server 2025 Standard (Desktop Experience) |
| Firmware | UEFI |
| TPM | 2.0 |
| Secure Boot | Enabled |
| Processor | 1 Processor / 4 Cores |
| Memory | 4 GB |
| Virtual Disk | 60 GB (Thin Provisioned) |
| Network Adapter | LAN Segment |
| LAN Segment | LAN_C (192.168.120.0/24) |

**Figure 1.** VMware virtual machine configured with UEFI firmware and Secure Boot enabled.

![VMware Firmware Configuration](screenshots/install-configure-server/vmware-firmware.png)

**Figure 2.** VMware virtual machine configured with a Trusted Platform Module (TPM 2.0) and connected to the LAN_C network segment.

![VMware Network Configuration](screenshots/install-configure-server/vmware-network.png)

**Figure 3.** Windows Server 2025 Server Manager after the initial installation.

![Windows Server 2025 Server Manager](screenshots/install-configure-server/windows-server-manager.png)



