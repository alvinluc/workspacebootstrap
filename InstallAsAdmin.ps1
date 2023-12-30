function CheckAdminPrivileges {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) 
}

function InitialiseEnvironment {
    $COMPUTER_NAME = Read-Host "Create a new Workstation Name: "
    Rename-Computer -NewName $COMPUTER_NAME

    wsl --install

    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    powercfg -SETACTIVE e9a42b02-d5df-448d-aa00-03f14749eb61    

    Invoke-WebRequest https://github.com/microsoft/winget-cli/releases/download/v1.6.3133/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -out $env:USERPROFILE\Documents\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Add-AppxPackage $env:USERPROFILE\Documents\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Remove-Item $env:USERPROFILE\Documents\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

    $chocolateyUrl = "https://chocolatey.org/install.ps1"
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString($chocolateyUrl))
}


function InstallApps {
    choco install -y googlechrome
    winget install Git.Git
    winget install 7zip.7zip
    winget install Notepad++.Notepad++
    winget install GnuWin32.Make
    winget install Docker.DockerDesktop
    winget install VMware.WorkstationPro

    winget install Microsoft.DirectX
    winget install Microsoft.DotNet.SDK.8
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
    winget install Microsoft.SQLServerManagementStudio
    winget install JanDeDobbeleer.OhMyPosh

    winget install DevToys
    winget install WinToys
    winget install Flow-Launcher.Flow-Launcher

    winget install Windscribe.Windscribe
    winget install Mozilla.Firefox
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
    winget install Daum.PotPlayer
    winget install den4b.ReNamer
    winget install AdrienAllard.FileConverter

    winget install Valve.Steam
    winget install GOG.Galaxy
    winget install EpicGames.EpicGamesLauncher
    winget install WeMod.WeMod

    choco install -y nerd-fonts-firacode --version=2.3.3
    choco install -y nerd-fonts-firamono --version=2.3.3
    choco install -y nerd-fonts-cascadiacode --version=2.3.3
    
    choco install -y sysinternals
    choco install -y filezilla
    choco install -y nvm
    choco instlal -y pyenv-win
    
      
    Invoke-WebRequest https://github.com/LesFerch/WinSetView/archive/refs/tags/2.77.zip -out $env:USERPROFILE\Documents\WinSetView.zip
    Expand-Archive $env:USERPROFILE\Documents\WinSetView.zip -DestinationPath $env:USERPROFILE\Documents\WinSetView -Force
    Remove-Item $env:USERPROFILE\Documents\WinSetView.zip
   
}


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

if (CheckAdminPrivileges -eq $true) {

    $isSuccess = False
    
    try {
        InitialiseEnvironment
        $isSuccess = True
    } 
    catch {
        Write-Host "An error occurred when initialising environment:"
        Write-Host $_
        $isSuccess = False
    }



    if ($isSuccess -eq $false) {
        exit
    }
    else {
        try {
            InstallApps
        }
        catch {
            Write-Host "An error occurred when installing apps:"
            Write-Host $_
        }    

    }    
}



