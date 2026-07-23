# Configure Kerberos for Web IIS Service Authentication

## Objective

Configure Microsoft Internet Information Services (IIS) to use Kerberos authentication with Active Directory and verify the authentication process using Wireshark.

## Install and Configure IIS

The **Web Server (IIS)** role was installed using **Server Manager → Add Roles and Features**.

During installation, the **Windows Authentication** role service was selected.

> Figure 54. Windows Authentication role service selected during IIS installation.

![Windows Authentication role service selected during IIS installation](../evidence/screenshots/iis-kerberos/iis-role-services-windows-authentication.png)

> Figure 55. IIS installation completed successfully.

![IIS installation completed successfully](../evidence/screenshots/iis-kerberos/iis-installation-completed.png)

> Figure 56. IIS Manager showing the Default Web Site after installation.

![IIS Manager showing the Default Web Site after installation](../evidence/screenshots/iis-kerberos/iis-manager-default-site.png)

> Figure 57. Default IIS website successfully loaded before Windows Authentication was configured.

![Default IIS website successfully loaded before Windows Authentication was configured](../evidence/screenshots/iis-kerberos/iis-default-web-page.png)  

## Configure Windows Authentication

The authentication settings for the **Default Web Site** were configured in IIS Manager.

Configuration:

- Anonymous Authentication → **Disabled**
- Windows Authentication → **Enabled**

This configuration requires users to authenticate using Windows credentials before accessing the website.

> Figure 58. Windows Authentication enabled and Anonymous Authentication disabled.

![Windows Authentication enabled and Anonymous Authentication disabled](../evidence/screenshots/iis-kerberos/iis-windows-authentication-enabled.png)  

## Configure Authentication Providers

The Windows Authentication providers were configured.

Provider order:

1. Negotiate
2. NTLM

Placing **Negotiate** first ensures IIS attempts Kerberos authentication before falling back to NTLM.

> Figure 59. Windows Authentication providers configured.

![Windows Authentication providers configured](../evidence/screenshots/iis-kerberos/iis-authentication-providers.png)

## Create IIS Service Account

A dedicated Active Directory service account was created for IIS.

Configuration:

| Setting | Value |
|---------|-------|
| Full Name | HTTP Service |
| User Logon Name | http |
| Password Never Expires | Enabled |

> Figure 60. HTTP service account created.

![HTTP service account created](../evidence/screenshots/iis-kerberos/http-service-user-created.png)  

> Figure 61. HTTP service account properties.  
![HTTP service account properties](../evidence/screenshots/iis-kerberos/http-service-user-properties-1.png)    
![HTTP service account properties](../evidence/screenshots/iis-kerberos/http-service-user-properties-2.png)

## Register Service Principal Names (SPNs)

The required HTTP SPNs were registered for the IIS service account.

```powershell
setspn -S HTTP/WIN-HSDL1A303DJ http
setspn -S HTTP/WIN-HSDL1A303DJ.parkhomenko.test http
```

The configuration was verified using:

```powershell
setspn -L http
```

Registered SPNs:

```text
HTTP/WIN-HSDL1A303DJ
HTTP/WIN-HSDL1A303DJ.parkhomenko.test
```

> Figure 62. HTTP Service Principal Names successfully registered.  
![HTTP Service Principal Names successfully registered](../evidence/screenshots/iis-kerberos/spn-registration-success.png)

## Configure IIS Application Pool

The **DefaultAppPool** initially used the default **ApplicationPoolIdentity**.

The identity was then changed to the dedicated Active Directory service account:

```text
http@parkhomenko.test
```

The IIS configuration was updated to use the application pool credentials for Kerberos authentication.

```powershell
Import-Module WebAdministration

Set-WebConfigurationProperty `
-Filter "system.webServer/security/authentication/windowsAuthentication" `
-PSPath "IIS:\" `
-Location "Default Web Site" `
-Name "useAppPoolCredentials" `
-Value True

iisreset
```

> Figure 63. Default Application Pool identity before configuration.

![Default Application Pool identity before configuration](../evidence/screenshots/iis-kerberos/application-pool-default-identity.png)

> Figure 64. Application Pool configured to use the HTTP service account.

![Application Pool configured to use the HTTP service account](../evidence/screenshots/iis-kerberos/application-pool-http-service-account.png)

> Figure 65. Application Pool credentials enabled for Kerberos authentication.

![Application Pool credentials enabled for Kerberos authentication](../evidence/screenshots/iis-kerberos/useapppoolcredentials-enabled.png)

> Figure 66. IIS successfully restarted after configuration.

![IIS successfully restarted after configuration](../evidence/screenshots/iis-kerberos/iisreset-success.png)  

## Verify DNS Resolution

Before testing Kerberos authentication, DNS resolution was verified from the Windows 11 client.

The client successfully resolved the Fully Qualified Domain Name (FQDN) of the IIS server.

> Figure 67. DNS host record configured on the Domain Controller.

![DNS host record configured on the Domain Controller](../evidence/screenshots/iis-kerberos/dns-manager-host-record.png)

> Figure 68. Successful DNS name resolution using nslookup.

![Successful DNS name resolution using nslookup](../evidence/screenshots/iis-kerberos/nslookup-hostname-success.png)

> Figure 69. Windows 11 client IP configuration.

![Windows 11 client IP configuration](../evidence/screenshots/iis-kerberos/client-ipconfig-domain.png)  

## Verify IIS Authentication

The Windows 11 client accessed the IIS website using its Fully Qualified Domain Name (FQDN):

```text
http://WIN-HSDL1A303DJ.parkhomenko.test
```

Windows Authentication prompted for domain credentials.

After successful authentication, the IIS website loaded successfully.

> Figure 70. Windows Authentication credential prompt.

![Windows Authentication credential prompt](../evidence/screenshots/iis-kerberos/iis-browser-authentication-prompt.png)

> Figure 71. IIS website successfully accessed after authentication.

![IIS website successfully accessed after authentication](../evidence/screenshots/iis-kerberos/iis-browser-authenticated.png)  

## Verify Kerberos Authentication Using Wireshark

A packet capture was performed on the Windows 11 client using Wireshark.

Display filters:

```text
kerberos
```

and

```text
tcp.port == 88
```

The capture contains Kerberos authentication traffic between the client and the Domain Controller.

Observed Kerberos packets:

- TGS-REQ
- TGS-REP

These packets confirm that the client requested and received a Kerberos service ticket from the Key Distribution Center (KDC).

The Kerberos ticket cache was cleared using:

```cmd
klist purge
```

Although `klist` did not display cached tickets in this lab environment after the purge, the successful authentication to the IIS website together with the captured **TGS-REQ** and **TGS-REP** packets confirms that Kerberos authentication was successfully performed.

> Figure 72. Wireshark capture filtered using `kerberos`.

![Wireshark capture filtered using kerberos](../evidence/screenshots/iis-kerberos/wireshark-kerberos-tgs.png)

> Figure 73. Kerberos ticket cache cleared using `klist purge`.

![Kerberos ticket cache cleared using klist purge](../evidence/screenshots/iis-kerberos/klist-purge.png)

# Result

Kerberos authentication for the IIS web service was successfully configured.

Windows Authentication was enabled for the Default Web Site, with **Negotiate** configured as the preferred authentication provider. A dedicated Active Directory service account was created, HTTP Service Principal Names (SPNs) were registered, and the IIS Application Pool was configured to use the service account credentials. DNS resolution using the Fully Qualified Domain Name (FQDN) was successfully verified before authentication testing. The Windows 11 client authenticated successfully to the IIS website, and Wireshark confirmed Kerberos authentication by capturing **TGS-REQ** and **TGS-REP** messages exchanged between the client and the Domain Controller.