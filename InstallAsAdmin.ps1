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

    enum PackageManagers {
        Chocolatey
        Winget
    }

    $wingetPackages = (      
        @{ Name = "Git.Git"; Manager = [PackageManagers]::Winget },
        @{ Name = "GnuWin32.Make"; Manager = [PackageManagers]::Winget },
        @{ Name = "Docker.DockerDesktop"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.VC++2015-2022Redist-x86"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.VC++2015-2022Redist-x64"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.DotNet.SDK.6"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.AzureCosmosEmulator"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.AzureDataStudio"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.AzureFunctionsCoreTools"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.PowerToys"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.Powershell"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.SQLServerManagementStudio"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.VisualStudioCode"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.VisualStudio.2022.Enterprise"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.WindowsTerminal"; Manager = [PackageManagers]::Winget },        
        @{ Name = "JanDeDobbeleer.OhMyPosh"; Manager = [PackageManagers]::Winget },
        @{ Name = "pnpm.pnpm"; Manager = [PackageManagers]::Winget },      
        @{ Name = "Postman.Postman"; Manager = [PackageManagers]::Winget },
        @{ Name = "XavierRoche.HTTrack"; Manager = [PackageManagers]::Winget },
        
        @{ Name = "Cryptomator.Cryptomator"; Manager = [PackageManagers]::Winget },
        @{ Name = "Daum.PotPlayer"; Manager = [PackageManagers]::Winget },
        @{ Name = "Google.Chrome"; Manager = [PackageManagers]::Winget },
        @{ Name = "IrfanSkilJan.IrfanView"; Manager = [PackageManagers]::Winget },
        @{ Name = "KeepassXCTeam.KeePassXC"; Manager = [PackageManagers]::Winget },       
        @{ Name = "LizardByte.Sunshine"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.DirectX"; Manager = [PackageManagers]::Winget },
        @{ Name = "Microsoft.XboxApp"; Manager = [PackageManagers]::Winget },
        @{ Name = "RARLab.WinRAR"; Manager = [PackageManagers]::Winget },
        @{ Name = "SumatraPDF.SumatraPDF"; Manager = [PackageManagers]::Winget },
        @{ Name = "Tonec.InternetDownloadManager"; Manager = [PackageManagers]::Winget },
        @{ Name = "qBittorrent.qBittorrent"; Manager = [PackageManagers]::Winget },  
        @{ Name = "VivaldiTechnologies.Vivaldi"; Manager = [PackageManagers]::Winget }, 
        @{ Name = "Winamp.Winamp"; Manager = [PackageManagers]::Winget },
        @{ Name = "Windscribe.Windscribe"; Manager = [PackageManagers]::Winget },

        # Auto Dark Mode
        @{ Name = "XP8JK4HZBVF435"; Manager = [PackageManagers]::Winget }
        
    )

    $chocolateyPackages = (
        @{ Name = "ffmpeg"; Manager = [PackageManagers]::Chocolatey },    
        @{ Name = "filezilla"; Manager = [PackageManagers]::Chocolatey },
        @{ Name = "rufus"; Manager = [PackageManagers]::Chocolatey },
        @{ Name = "servicebusexplorer"; Manager = [PackageManagers]::Chocolatey },
        @{ Name = "pyenv-win"; Manager = [PackageManagers]::Chocolatey },
        @{ Name = "yt-dlp"; Manager = [PackageManagers]::Chocolatey }
    )

    $packages = $wingetPackages + $chocolateyPackages

    foreach ($package in $packages) {
        if ($package.Name -eq "") {} else {

            if ($package.Manager -eq [PackageManagers]::Chocolatey) {
                choco install -y $package.Name --ignore-checksums
            }
            elseif ($package.Manager -eq [PackageManagers]::Winget) {
                winget install --id $package.Name --force
            }
            else {
                Write-Host 'No package manager found for ' + $package
            }
        }           
    }
}



function Download ($url) {
    $fileName = Split-Path $url -leaf
    $downloadPath = "$env:USERPROFILE\Downloads\$fileName"
    Invoke-WebRequest $url -out $downloadPath
    return $downloadPath
}


function UnzipFromWeb ($url) {
    $downloadPath = Download $url
    $targetDir = "$env:USERPROFILE\Downloads\$((Get-ChildItem $downloadPath).BaseName)"
    Expand-Archive $downloadPath -DestinationPath $targetDir -Force
    Remove-Item $downloadPath
    return $targetDir
}

function InstallFonts {
    $destinationFolder = 'C:\Windows\Fonts'
    $windowsFontFolder = (new-object -com shell.application).NameSpace($destinationFolder)

    $cascadiaCodeFolder = UnzipFromWeb 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip'
    $firaCodeFolder = UnzipFromWeb 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip'
    $firaMonoCodeFolder = UnzipFromWeb 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraMono.zip'

    foreach ($file in "$cascadiaCodeFolder\*.otf") {     
        Get-ChildItem $file | ForEach-Object { $windowsFontFolder.CopyHere($_.fullname) }
    }

    foreach ($file in "$firaCodeFolder\*.ttf") {     
        Get-ChildItem $file | ForEach-Object { $windowsFontFolder.CopyHere($_.fullname) }
    }

      
    foreach ($file in "$firaMonoCodeFolder\*.otf") {     
        Get-ChildItem $file | ForEach-Object { $windowsFontFolder.CopyHere($_.fullname) }
    }

    Remove-Item $cascadiaCodeFolder -Recurse -Force
    Remove-Item $firaCodeFolder -Recurse -Force
    Remove-Item $firaMonoCodeFolder -Recurse -Force

}

function InstallWSL {
    wsl --install
    wsl --set-default-version 2
}

function InstallNode {    
    Invoke-WebRequest https://get.pnpm.io/install.ps1 -useb | iex
}


Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

if (CheckAdminPrivileges -eq $true) {    
    InitialiseEnvironment
    InstallPackageManagers
    InstallWSL
    InstallFonts
    InstallPackages
    InstallNode     
}
