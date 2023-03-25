function CheckAdminPrivileges {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    return (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) 
}

function ConfigureGit ($name, $email) {    
    git config --global user.name "$name"
    git config --global user.email "$email"
    git config --global core.autocrlf false
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
    
    ssh-keygen -b 4096 -t rsa
}

function ConfigureWorkspace {
    if (Test-Path -Path "$env:USERPROFILE\Workspace") {  }
    else {
        New-Item -ItemType "directory" -Path "$env:USERPROFILE" -Name "Workspace"
        New-Item $env:USERPROFILE\Workspace\Themes\temp -ItemType Directory -ea 0
    }
}

function ConfigureWindowsTerminal {
    if (Test-Path -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState") {  }
    else {
        New-Item -ItemType "directory" -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\" -Name "LocalState"
    }

    Invoke-WebRequest https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/windows-terminal-settings.json -out $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
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


function ConfigureVsCode {

    $extensions = Invoke-WebRequest https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/vscode_extensions.list

    foreach ($extension in $extensions.Content) {       
        code --install-extension $extension --force        
    }
    
    if (Test-Path -Path "$env:APPDATA\Code\User") {  }
    else {
        New-Item -ItemType "directory" -Path "$env:APPDATA\Code\" -Name "User"
    }

    Invoke-WebRequest https://raw.githubusercontent.com/alvinluc/workspacebootstrap/master/Resources/visual-studio-code-settings.json -out $env:APPDATA\Code\User\settings.json
    
}

function ConfigureDotnetPackages {
    dotnet nuget add source https://api.nuget.org/v3/index.json 
    dotnet dev-certs https --trust
    dotnet tool install --global dotnet-ef
    dotnet tool install --global csharprepl
}


function ConfigurePythonEnv($PYTHON_VER) {
    pyenv install $PYTHON_VER
    pyenv global $PYTHON_VER
}

if (CheckAdminPrivileges -eq $true) {} else {    
    $NAME = Read-Host "Please enter Git Name"
    $EMAIL = Read-Host "Please enter Git Email"
    $PYTHON_VER = Read-Host "Enter Python version to install"

    ConfigureGit($NAME, $EMAIL)
    ConfigureSSH
    ConfigureWorkspace
    ConfigureWindowsTerminal
    ConfigurePowershell
    ConfigureVsCode
    ConfigureDotnetPackages
    ConfigurePythonEnv($PYTHON_VER)
}