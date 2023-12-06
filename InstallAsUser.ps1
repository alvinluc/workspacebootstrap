function CheckAdminPrivileges {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) 
}

function ConfigureGit {
    $name = Read-Host "Please enter your full name for Git"
    $name = $name.Trim()
    git config --global user.name "$name"

    $email = Read-Host "Please enter the email to use for Git"   
    $email = $email.Trim()   
    git config --global user.email $email

    git config --global core.autocrlf true
    git config --global init.defaultBranch main
    git config --global push.default current
    git config --global pull.rebase true
    git config --global core.editor 'code -w'
}

function ConfigureSSH {
    if (Test-Path -Path "$env:USERPROFILE\.ssh") {  }
    else {
        New-Item -ItemType "directory" -Path "$env:USERPROFILE" -Name ".ssh"
    }
    
    $email = git config --global user.email
    ssh-keygen -b 4096 -t rsa -C "$email"
}

function ConfigureDotnetPackages {
    dotnet dev-certs https --trust
    dotnet tool install --global dotnet-ef --version 8.0.0 # match dotnet sdk
}


function ConfigurePython {
    $defaultPythonVersion = '3.10.5'
    $prompt = Read-Host "Press enter to accept the Python version to install default: [$($defaultPythonVersion)]"
    $python_version = ($defaultPythonVersion, $prompt)[[bool]$prompt]
    pyenv install $python_version
    pyenv global $python_version
}

function ConfigureNode {
    nvm install lts
    nvm use lts
}

function ConfigurePowershell {
    if (Test-Path -Path "$env:USERPROFILE\Documents\Powershell") {  }
    else {
        New-Item -ItemType "directory" -Path "$env:USERPROFILE\Documents\" -Name "Powershell"
    }
  
    $modules = (
        "Posh-Git",
        "DockerCompletion",
        "PSReadLine",
        "Terminal-Icons"
    )
    
    foreach ($module in $modules) {
        Install-Module $module -Scope CurrentUser -Confirm:$False -Force
    }
    
    Invoke-WebRequest https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/Microsoft.PowerShell_profile.ps1 -out $env:USERPROFILE\Documents\Powershell\Microsoft.PowerShell_profile.ps1
}

function ConfigureWindowsTerminal {
    if (Test-Path -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState") {  }
    else {
        New-Item -ItemType "directory" -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\" -Name "LocalState"
    }

    Invoke-WebRequest https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/windows-terminal-settings.json -out $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
}


function ConfigureVisualStudioCode {

    if (Test-Path -Path "$env:APPDATA\Code\User") {  }
    else {
        New-Item -ItemType "directory" -Path "$env:APPDATA\Code\" -Name "User"
    }

    Invoke-WebRequest https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/visual-studio-code-settings.json -out $env:APPDATA\Code\User\settings.json

    $extensions = Invoke-WebRequest https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/vscode_extensions.list  -ContentType "text/plain"
    $extensions = $extensions.tostring() -split "[`r`n]"
    
    foreach ($extension in $extensions) {
        code --install-extension $extension --force
    }   
}

function ConfigureWorkspace {
    if (Test-Path -Path "$env:USERPROFILE\Workspace") {  }
    else {
        New-Item -ItemType "directory" -Path "$env:USERPROFILE" -Name "Workspace"
        New-Item $env:USERPROFILE\Workspace\Themes\temp -ItemType Directory -ea 0
    }
}

if (CheckAdminPrivileges -eq $true) {} else {     
    ConfigureGit
    ConfigureSSH
    ConfigureDotnetPackages
    ConfigurePython
    ConfigureNode
    ConfigurePowershell
    ConfigureWindowsTerminal   
    ConfigureVisualStudioCode
    ConfigureWorkspace
}