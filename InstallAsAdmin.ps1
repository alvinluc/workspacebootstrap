function CheckAdminPrivileges {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) 
}

function InitialiseEnvironment {
    $COMPUTER_NAME = Read-Host "What is your workstation name?"
    Rename-Computer -NewName $COMPUTER_NAME

    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    powercfg -SETACTIVE e9a42b02-d5df-448d-aa00-03f14749eb61
    wsl --update
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
    
    winget install Git.Git
    winget install GnuWin32.Make
    winget install Docker.DockerDesktop
    winget install Oracle.VirtualBox

    winget install Microsoft.DirectX
    winget install Microsoft.DotNet.SDK.6   
    winget install Microsoft.PerfView
    winget install Microsoft.PowerToys
    winget install Microsoft.PowerShell
    winget install Microsoft.AzureCLI
    winget install Microsoft.Azure.FunctionsCoreTools
    winget install Microsoft.Azure.CosmosEmulator
    winget install Microsoft.Azure.StorageExplorer
    winget install Microsoft.WindowsTerminal
    winget install Microsoft.VisualStudioCode
    winget install Microsoft.VisualStudio.2022.Enterprise
    winget install Microsoft.VisualStudio.2022.BuildTools
    winget install Microsoft.SQLServerManagementStudio
    winget install JanDeDobbeleer.OhMyPosh

    winget install Windscribe.Windscribe
    winget install Mozilla.Firefox
    winget install Google.Chrome
    winget install Tonec.InternetDownloadManager
    winget install qBittorrent.qBittorrent
    winget install Malwarebytes.Malwarebytes
    winget install Cryptomator.Cryptomator
    winget install KeePassXCTeam.KeePassXC

    winget install RARLab.WinRAR
    winget install Gyan.FFmpeg
    winget install yt-dlp.yt-dlp
    winget install XavierRoche.HTTrack    
    winget install IrfanSkiljan.IrfanView
    winget install SumatraPDF.SumatraPDF    
    winget install clsid2.mpc-hc   
    winget install den4b.ReNamer
    winget install AdrienAllard.FileConverter
        
    winget install Valve.Steam
    winget install GOG.Galaxy
    winget install EpicGames.EpicGamesLauncher
    winget install WeMod.WeMod
      

    choco install -y filezilla pyenv-win nvm --ignore-checksums
   
}

funciton UpdateWSL {
    wsl --update
}


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

if (CheckAdminPrivileges -eq $true) {    
    InitialiseEnvironment
    InstallPackageManagers
    InstallPackages
    UpdateWSL
}
