# Install and Configure Windows Server 2025 – Active Directory

## Overview

In this part of the lab, a Windows Server 2025 virtual machine was prepared and configured as the first Active Directory Domain Controller. The server was installed in VMware Workstation Pro with TPM 2.0 and Secure Boot enabled, connected to the internal lab network, and configured with a static IPv4 address. Active Directory Domain Services (AD DS) and DNS Server roles were installed, and the server was promoted to the first Domain Controller of a new forest and its root domain. The Domain Controller configuration was then verified by creating organizational units (OUs) and user accounts, verifying Active Directory and DNS settings, configuring a reverse lookup zone, and validating the domain services using PowerShell cmdlets.

### Virtual Machine Configuration

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

![VMware Firmware Configuration](../evidence/screenshots/install-configure-server/vmware-firmware.png)

**Figure 2.** VMware virtual machine configured with a Trusted Platform Module (TPM 2.0) and connected to the LAN_C network segment.

![VMware Network Configuration](../evidence/screenshots/install-configure-server/vmware-network.png)

## Configure Domain controller and Active Directory

**Figure 3.** Windows Server 2025 Server Manager after the initial installation.

![Windows Server 2025 Server Manager](../evidence/screenshots/install-configure-server/windows-server-manager.png)

### Configure Static Network Settings

Before installing Active Directory Domain Services (AD DS), the server was configured with a static IPv4 address. Since the server will become the Domain Controller and DNS server for the domain, a static network configuration is required to ensure reliable authentication and name resolution.

The following network settings were configured:

| Setting | Value |
|---------|-------|
| IPv4 Address | 192.168.120.3 |
| Subnet Mask | 255.255.255.0 |
| Default Gateway | 192.168.120.1 |
| Preferred DNS Server | 192.168.120.3 |
| Alternate DNS Server | 8.8.8.8 |

**Figure 4.** Static IPv4 and DNS configuration for the Windows Server 2025 Domain Controller.

![IPv4 Configuration](../evidence/screenshots/install-configure-server/ipv4-properties.png)

The network configuration was verified using the `ipconfig /all` command to confirm that the static IP address, subnet mask, default gateway, and DNS server settings were correctly applied.

**Figure 5.** Verification of the server network configuration using `ipconfig /all`.

![IP Configuration Verification](../evidence/screenshots/install-configure-server/ipconfig-all.png)

Connectivity to the pfSense gateway was verified using ICMP echo requests. Successful replies confirmed that the server was connected to the correct internal network before installing Active Directory.

**Figure 6.** Successful connectivity test to the default gateway.

![Gateway Ping](../evidence/screenshots/install-configure-server/ping-gateway.png)


### Install Active Directory Domain Services

After verifying the network configuration, the Active Directory Domain Services (AD DS) and DNS Server roles were installed using the **Add Roles and Features Wizard** in Server Manager.

The following server roles were selected:

- Active Directory Domain Services
- DNS Server

**Figure 7.** Selected server roles for the Active Directory installation.

![Server Roles](../evidence/screenshots/install-configure-server/server-roles.png)

The installation automatically included the required management tools, including:

- Group Policy Management
- Remote Server Administration Tools
- Active Directory Administrative Center
- Active Directory module for Windows PowerShell
- DNS Server Tools

**Figure 8.** Confirmation page showing the selected roles and automatically installed management tools.

![Installation Confirmation](../evidence/screenshots/install-configure-server/confirmation.png)

After the installation completed successfully, Server Manager displayed a notification indicating that additional configuration was required to promote the server to a Domain Controller.

**Figure 9.** AD DS installation completed successfully and the server is ready for promotion.

![Installation Completed](../evidence/screenshots/install-configure-server/installation-complete.png)


### Promote the Server to a Domain Controller

The server was promoted as the first Domain Controller by creating a new Active Directory forest.

The following root domain name was configured:

```text
parkhomenko.test
```

The default Active Directory storage locations were accepted.

| Component | Location |
|-----------|----------|
| AD Database | C:\Windows\NTDS |
| Log Files | C:\Windows\NTDS |
| SYSVOL | C:\Windows\SYSVOL |

**Figure 10.** Default locations for the Active Directory database, log files, and SYSVOL.

![AD Paths](../evidence/screenshots/install-configure-server/ad-paths.png)

The configuration summary confirmed that the server would become the first Domain Controller in a new forest named **parkhomenko.test**. The DNS Server and Global Catalog roles were enabled automatically.

**Figure 11.** Review of the Active Directory deployment configuration before installation.

![Review Options](../evidence/screenshots/install-configure-server/review-options.png)

The Active Directory Configuration Wizard also generated a reusable Windows PowerShell deployment script containing the selected installation parameters. This script can be used to automate future deployments with the same configuration.

- [`scripts/install-ad-ds.ps1`](../evidence/logs/install-ad-ds.ps1)

Before the promotion process began, the Active Directory Configuration Wizard successfully validated all prerequisite checks. The DNS delegation warning was expected because this was the first Domain Controller in a new isolated forest.

**Figure 12.** Successful prerequisite validation before Domain Controller promotion.

![Prerequisites Check](../evidence/screenshots/install-configure-server/prerequisites-check.png)

After all prerequisite checks passed successfully, the server was promoted to a Domain Controller. The installation configured the new Active Directory forest, installed the DNS service, created the Active Directory database, configured SYSVOL, and automatically restarted the server.


### Verify Domain Controller Installation

After the automatic reboot, the server joined the newly created Active Directory forest and became the first Domain Controller for the **parkhomenko.test** domain.

Server Manager displayed both the **Active Directory Domain Services (AD DS)** and **DNS** management consoles, confirming that the Domain Controller promotion completed successfully.

The server was now configured as:

- First Domain Controller
- Root Domain Controller
- DNS Server
- Global Catalog Server

**Figure 13.** Server Manager after successful Domain Controller promotion.

![Server Manager AD DS](../evidence/screenshots/install-configure-server/server-manager-ad-ds.png)

## Verify Domain Controller (DC), Active Directory and DNS Settings

After promoting the server to the first Domain Controller, the Active Directory and DNS configuration was verified. The verification included reviewing the Domain Controller properties, exploring the default Active Directory objects, creating domain users and Organizational Units (OUs), and validating both Forward and Reverse Lookup Zones in DNS Manager.

### Verify Server Properties

The server properties were verified using **Server Manager → Local Server**. The server was successfully joined to the **parkhomenko.test** domain and configured with the static IPv4 address **192.168.120.3**. The Local Server page also confirmed that the server was running Windows Server 2025 and operating as the first Domain Controller for the new Active Directory forest.

**Figure 14.** Server Manager showing the Domain Controller configuration after Active Directory deployment.

![Server Manager - Local Server](../evidence/screenshots/install-configure-server/server-manager-local-server.png)

### Verify Active Directory Domain Services

The **Active Directory Users and Computers** console was opened from **Server Manager → AD DS**. The newly created forest **parkhomenko.test** contained the default Active Directory containers, including **Builtin**, **Computers**, **Domain Controllers**, **ForeignSecurityPrincipals**, **Managed Service Accounts**, and **Users**.

The **Builtin** container stores predefined administrative security groups that are created automatically during the Active Directory installation. These groups allow administrative tasks to be delegated without granting full Domain Administrator privileges.

The **Users** container stores both built-in user accounts and default security groups. Built-in user accounts include **Administrator**, **Guest**, and **krbtgt**, while default security groups include **Domain Admins**, **Domain Users**, **Enterprise Admins**, and **Group Policy Creator Owners**. User accounts represent individual identities that authenticate to the domain, whereas security groups simplify permission management by assigning access rights to multiple users simultaneously.

**Figure 15.** Default Active Directory containers, built-in users, and security groups created after promoting the server to a Domain Controller.

![Active Directory Default Containers](../evidence/screenshots/install-configure-server/ad-default-containers.png)

### Create a Domain User

A new domain user account was created in the **Users** container using the naming convention required by the laboratory. The account was successfully created in the Active Directory domain and appears together with the default user accounts.

**Figure 16.** New domain user account created in the Users container.

![Domain User](../evidence/screenshots/install-configure-server/domain-user-created.png)

### Create Organizational Units (OU)

Three Organizational Units (OUs) were created under the **parkhomenko.test** domain:

- HR
- Schools
- Management

Organizational Units provide a logical structure for grouping users and other Active Directory objects, simplifying administration and the application of Group Policy.

**Figure 17.** Organizational Units created in the Active Directory domain.

![Organizational Units](../evidence/screenshots/install-configure-server/organizational-units.png)

### Create Users in Organizational Units

One user account was created in each Organizational Unit to verify that Active Directory objects could be organized according to the domain structure.

**Figure 18.** User account created in the HR Organizational Unit.

![HR User](../evidence/screenshots/install-configure-server/ou-hr-user.png)

**Figure 19.** User account created in the Schools Organizational Unit.

![Schools User](../evidence/screenshots/install-configure-server/ou-schools-user.png)

**Figure 20.** User account created in the Management Organizational Unit.

![Management User](../evidence/screenshots/install-configure-server/ou-management-user.png)

### Verify DNS Forward Lookup Zone

The DNS configuration was verified using **DNS Manager**. The **Forward Lookup Zone** for **parkhomenko.test** contained the DNS records automatically registered during the Domain Controller promotion. These records allow clients to locate the services required for Active Directory operation.

The most important records include:

| Record | Purpose |
|---------|----------|
| **SOA** | Identifies the primary DNS server for the zone. |
| **NS** | Specifies the authoritative DNS server for the domain. |
| **Host (A)** | Maps the Domain Controller hostname to its IPv4 address. |
| **_ldap** | Allows clients to locate LDAP directory services. |
| **_kerberos** | Allows clients to locate Kerberos authentication services. |
| **_tcp** | Stores TCP service location records. |
| **_udp** | Stores UDP service location records. |
| **_msdcs** | Stores Microsoft Active Directory service records used by domain controllers. |

These records are created automatically during Active Directory installation and are required for client authentication, domain controller discovery, and directory service operation.

**Figure 21.** Forward Lookup Zone containing Active Directory DNS records.

![Forward Lookup Zone](../evidence/screenshots/install-configure-server/dns-forward-zone.png)

### Configure and Verify Reverse Lookup Zone

A new **Active Directory-Integrated Primary Reverse Lookup Zone** was created for the **192.168.120.0/24** network. During the configuration wizard, the network address **192.168.120** was specified, creating the reverse lookup zone **120.168.192.in-addr.arpa**.

The successful creation of the reverse lookup zone confirms that reverse DNS name resolution is available within the Active Directory environment.

**Figure 22.** Reverse Lookup Zone configured for the 192.168.120.0/24 network.

![Reverse Lookup Zone](../evidence/screenshots/install-configure-server/dns-reverse-zone.png)