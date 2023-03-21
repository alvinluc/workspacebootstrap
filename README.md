# Machine Customisation

Personal repo enabling a quick way to bootstrap commonly used packages and dev settings to be synced across Windows machines. 

(Requires Win 10+ and Powershell)

## Installation

As admin:

```powershell
Invoke-Expression $(Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/alvinluc/customisation/master/InstallAsAdmin.ps1)
```

(Advisable to reboot before this but not mandatory)

As normal user in a Powershell Core window:

```powershell
Invoke-Expression $(Invoke-WebRequest -UseBasicParsing  https://raw.githubusercontent.com/alvinluc/customisation/master/InstallAsUser.ps1)
```
