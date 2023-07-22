$env:DOTNET_CLI_TELEMETRY_OPTOUT = 1

oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\clean-detailed.omp.json | Invoke-Expression

Import-Module Terminal-Icons
Import-Module posh-git
Import-Module DockerCompletion
Import-Module PSReadLine


Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows



Set-Alias -Name w -Value NavigateToWorkspace
Set-Alias -Name cleansub -Value CleanSubTitles

$WindowsAppsPath = "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps"
$env:Path = ($env:Path.Split(';') | Where-Object -FilterScript { $_ -ne $WindowsAppsPath }) -join ';'
$env:Path += ";C:\Program Files\WinHTTrack"
$env:Path += ";$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps"

WinScreenfetch

# PowerShell parameter completion shim for the git CLI
Register-ArgumentCompleter -Native -CommandName git -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    git complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# PowerShell parameter completion shim for the docker CLI
Register-ArgumentCompleter -Native -CommandName docker -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    docker complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

function NavigateToWorkspace { 
    Set-Location -Path $env:USERPROFILE\Workspace 
}

function yt ($url) {
    yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0  --output "%USERPROFILE%\Downloads\temp\%(title)s.%(ext)s" "$url"
}

function ytv($url) {
    yt-dlp --yes-playlist -o "%USERPROFILE%\Downloads\temp\%(title)s.%(ext)s" --embed-chapters "$url"
}

function httr($url) {    
    httrack --disable-security-limits --connection-per-second=50 --sockets=80 --keep-alive --verbose --advanced-progressinfo  -F 'Mozilla/5.0 (X11;U; Linux i686; en-GB; rv:1.9.1) Gecko/20090624 Ubuntu/9.04 (jaunty) Firefox/3.5' -i --footer " " -s0 -m -r5 -d $url -O $env:USERPROFILE\Workspace\Themes\temp
}

function CleanSubTitles {
    Get-ChildItem *.srt -Recurse | foreach { Remove-Item -Path $_.FullName }
    Get-ChildItem *.vtt -Recurse | foreach { Remove-Item -Path $_.FullName }
}