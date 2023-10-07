function CheckAdminPrivileges {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) 
}

function InitialiseEnvironment {
    $COMPUTER_NAME = Read-Host "What is your workstation name?"
    Rename-Computer -NewName $COMPUTER_NAME

    powercfg -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
}

function InstallPackageManagers {
    $hasPackageManager = Get-AppPackage -name 'Microsoft.DesktopAppInstaller'
    if (!$hasPackageManager -or [version]$hasPackageManager.Version -lt [version]"1.10.0.0") {
        Start-Process ms-appinstaller:?source=https://aka.ms/getwinget
        Read-Host -Prompt "Press enter to continue..."
    }

    $chocolateyUrl = "https://chocolatey.org/install.ps1"
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($chocolateyUrl))

    choco feature enable -n=useRememberedArgumentsForUpgrades
}


function InstallPackages {
    choco install -y nerd-fonts-firacode --version=2.3.3
    choco install -y nerd-fonts-firamono --version=2.3.3
    choco install -y nerd-fonts-cascadiacode --version=2.3.3
    choco install -y 7zip cryptomator directx ffmpeg filezilla file-converter firefox httrack keepassxc irfanview internet-download-manager mpc-hc-clsid2 sumatrapdf windscribe qbittorrent yt-dlp --ignore-checksums
    choco install -y epicgameslauncher steam --ignore-checksums
    choco install -y git make docker-desktop dotnet-6.0-sdk pyenv-win nvm pwsh oh-my-posh vscode --ignore-checksums
    choco install -y visualstudio2022enterprise --ignore-checksums
}



function InitialiseWSL {
    wsl --update
}


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

if (CheckAdminPrivileges -eq $true) {    
    InitialiseEnvironment
    InstallPackageManagers
    InitialiseWSL
    InstallPackages
}
