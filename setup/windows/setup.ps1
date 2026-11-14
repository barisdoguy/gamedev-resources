#Requires -Version 5.1
<#
.SYNOPSIS
    Sets up a Windows PC for game and real-time graphics development.

.DESCRIPTION
    - Installs the toolchain with winget: Visual Studio 2022 (C++ game workload),
      Git, CMake, Ninja, LLVM, engines, GPU debuggers, profilers and content tools.
    - Applies developer-friendly Windows settings (Developer Mode, long paths,
      file extensions, a C:\dev workspace).
    - Configures Git: LFS, sensible defaults, an SSH key, signed commits, and
      uploads the key to GitHub through the GitHub CLI.

    Safe to re-run: anything already installed or configured is skipped.
    Use -DryRun to see what would happen without changing anything.

.PARAMETER GitName
    Name used in Git commits. Asked interactively if omitted and not configured.

.PARAMETER GitEmail
    Email used in Git commits. Your GitHub "noreply" address keeps your real
    email private: https://github.com/settings/emails

.PARAMETER Skip
    Groups to leave out: VisualStudio, Editors, Engines, GraphicsTools, Art,
    Utilities, WindowsSettings, DefenderExclusion, PowerPlan, GitHub.

.PARAMETER Workspace
    Folder for your projects. Default: C:\dev

.PARAMETER DryRun
    Print the plan only. Nothing is installed or changed.

.EXAMPLE
    .\setup.ps1 -GitName "Your Name" -GitEmail "12345+you@users.noreply.github.com"

.EXAMPLE
    .\setup.ps1 -Skip Engines,Art -DryRun
#>
[CmdletBinding()]
param(
    [string]$GitName,
    [string]$GitEmail,
    [ValidateSet('VisualStudio', 'Editors', 'Engines', 'GraphicsTools', 'Art', 'Utilities',
        'WindowsSettings', 'DefenderExclusion', 'PowerPlan', 'GitHub')]
    [string[]]$Skip = @(),
    [string]$Workspace = 'C:\dev',
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --------------------------------------------------------------------------
# Packages. Every Id is checked against the winget catalog in CI.
# --------------------------------------------------------------------------
$Packages = [ordered]@{
    Core          = @(
        @{ Id = 'Git.Git'; Name = 'Git (includes Git LFS)' }
        @{ Id = 'GitHub.cli'; Name = 'GitHub CLI' }
        @{ Id = 'Microsoft.PowerShell'; Name = 'PowerShell 7' }
        @{ Id = 'Kitware.CMake'; Name = 'CMake' }
        @{ Id = 'Ninja-build.Ninja'; Name = 'Ninja' }
        @{ Id = 'LLVM.LLVM'; Name = 'LLVM / Clang' }
        @{ Id = 'Python.Python.3.13'; Name = 'Python 3.13' }
    )
    VisualStudio  = @(
        @{
            Id       = 'Microsoft.VisualStudio.2022.Community'
            Name     = 'Visual Studio 2022 Community (C++ game + desktop workloads)'
            Override = '--passive --wait --norestart --includeRecommended ' +
            '--add Microsoft.VisualStudio.Workload.NativeGame ' +
            '--add Microsoft.VisualStudio.Workload.NativeDesktop'
        }
    )
    Editors       = @(
        @{ Id = 'Microsoft.VisualStudioCode'; Name = 'Visual Studio Code' }
        @{ Id = 'JetBrains.Rider'; Name = 'JetBrains Rider (free for non-commercial use)' }
    )
    Engines       = @(
        @{ Id = 'EpicGames.EpicGamesLauncher'; Name = 'Epic Games Launcher (Unreal Engine)' }
        @{ Id = 'GodotEngine.GodotEngine'; Name = 'Godot Engine' }
        @{ Id = 'Unity.UnityHub'; Name = 'Unity Hub' }
    )
    GraphicsTools = @(
        @{ Id = 'BaldurKarlsson.RenderDoc'; Name = 'RenderDoc (GPU frame debugger)' }
        @{ Id = 'Microsoft.PIX'; Name = 'PIX (Direct3D 12 debugger and profiler)' }
        @{ Id = 'wolfpld.tracy'; Name = 'Tracy (frame profiler)' }
    )
    Art           = @(
        @{ Id = 'BlenderFoundation.Blender'; Name = 'Blender' }
        @{ Id = 'KDE.Krita'; Name = 'Krita' }
        @{ Id = 'Audacity.Audacity'; Name = 'Audacity' }
        @{ Id = 'OBSProject.OBSStudio'; Name = 'OBS Studio (devlogs, trailers)' }
    )
    Utilities     = @(
        @{ Id = '7zip.7zip'; Name = '7-Zip' }
        @{ Id = 'voidtools.Everything'; Name = 'Everything (instant file search)' }
    )
}

$OpenSshDir = Join-Path $env:WINDIR 'System32\OpenSSH'
$script:Failures = New-Object System.Collections.Generic.List[string]

# --------------------------------------------------------------------------
# Helpers
# --------------------------------------------------------------------------
function Write-Section([string]$Text) { Write-Host "`n==> $Text" -ForegroundColor Cyan }
function Write-Ok([string]$Text) { Write-Host "    [ok]   $Text" -ForegroundColor Green }
function Write-Skipped([string]$Text) { Write-Host "    [skip] $Text" -ForegroundColor DarkGray }
function Write-Planned([string]$Text) { Write-Host "    [plan] $Text" -ForegroundColor Magenta }
function Write-Problem([string]$Text) { Write-Host "    [warn] $Text" -ForegroundColor Yellow }

$SkippedGroups = @($Skip)
function Test-Skipped([string]$Group) { return $SkippedGroups -contains $Group }

# Runs a change unless -DryRun is set, and records failures instead of
# stopping, so one broken step does not abort the whole setup.
function Invoke-Change([string]$Description, [scriptblock]$Action) {
    if ($DryRun) {
        Write-Planned $Description
        return
    }
    try {
        & $Action
        Write-Ok $Description
    }
    catch {
        Write-Problem "$Description failed: $($_.Exception.Message)"
        $script:Failures.Add($Description)
    }
}

function Sync-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

# Runs a native command and returns its stdout and stderr as strings.
# Windows PowerShell 5.1 turns redirected stderr into errors, which
# $ErrorActionPreference = 'Stop' would make fatal; the inner scope avoids that.
# Check $LASTEXITCODE afterwards.
function Invoke-NativeQuiet {
    $command = $args[0]
    $commandArgs = @($args | Select-Object -Skip 1)
    return & {
        $ErrorActionPreference = 'Continue'
        & $command @commandArgs 2>&1 | ForEach-Object { "$_" }
    }
}

function Test-WingetInstalled([string]$Id) {
    $null = Invoke-NativeQuiet winget list --id $Id --exact --accept-source-agreements --disable-interactivity
    return $LASTEXITCODE -eq 0
}

function Install-WingetPackage([hashtable]$Package) {
    $id = $Package['Id']
    $name = $Package['Name']
    if ($DryRun) {
        Write-Planned "winget install $id  ($name)"
        return
    }
    if (Test-WingetInstalled $id) {
        Write-Skipped "$name is already installed"
        return
    }

    Write-Host "    installing $name ..."
    $wingetArgs = @('install', '--id', $id, '--exact', '--source', 'winget', '--silent',
        '--accept-package-agreements', '--accept-source-agreements', '--disable-interactivity')
    if ($Package['Override']) {
        $wingetArgs += @('--override', $Package['Override'])
    }
    & winget @wingetArgs
    $code = $LASTEXITCODE

    # Some installers return non-zero for "installed, restart required".
    # Trust what winget reports as installed afterwards.
    if ($code -eq 0 -or (Test-WingetInstalled $id)) {
        Write-Ok $name
    }
    else {
        Write-Problem "$name could not be installed (winget exit code $code)"
        $script:Failures.Add($name)
    }
}

function Write-RegistryDword([string]$Path, [string]$Name, [int]$Value) {
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
    New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType DWord -Force | Out-Null
}

function Invoke-Git {
    & git @args
    if ($LASTEXITCODE -ne 0) {
        throw "git $($args -join ' ') exited with code $LASTEXITCODE"
    }
}

# Finds an existing Visual Studio (Community, Professional or Enterprise, any
# version, including previews) with vswhere, which ships with the VS Installer.
# winget only recognises the exact package it would install, so without this
# check a machine that already has Visual Studio gets a second, failing install.
function Get-VisualStudioInstall {
    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (-not (Test-Path $vswhere)) { return $null }

    $name = @(& $vswhere -latest -prerelease -property displayName 2>$null) | Select-Object -First 1
    if ($LASTEXITCODE -ne 0 -or -not $name) { return $null }

    $withGameWorkload = @(& $vswhere -latest -prerelease -property displayName `
            -requires Microsoft.VisualStudio.Workload.NativeGame 2>$null) | Select-Object -First 1
    return [pscustomobject]@{
        Name            = $name
        HasGameWorkload = [bool]$withGameWorkload
    }
}

function Get-GitConfig([string]$Key) {
    $value = Invoke-NativeQuiet git config --global --get $Key
    if ($LASTEXITCODE -ne 0) { return $null }
    return ($value -join '').Trim()
}

# --------------------------------------------------------------------------
# Preflight
# --------------------------------------------------------------------------
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($DryRun) {
    Write-Host 'DRY RUN: nothing will be installed or changed.' -ForegroundColor Magenta
}
else {
    if (-not $isAdmin) {
        throw 'Run this script from PowerShell opened with "Run as administrator".'
    }
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'winget was not found. Install "App Installer" from the Microsoft Store: https://apps.microsoft.com/detail/9NBLGGH4NNS1'
    }
    $logPath = Join-Path $HOME 'gamedev-setup.log'
    Start-Transcript -Path $logPath -Append | Out-Null
}

# --------------------------------------------------------------------------
# 1. Software
# --------------------------------------------------------------------------
foreach ($group in $Packages.Keys) {
    if ($group -ne 'Core' -and (Test-Skipped $group)) {
        Write-Section "$group (skipped)"
        continue
    }
    Write-Section $group

    if ($group -eq 'VisualStudio') {
        $existingVs = Get-VisualStudioInstall
        if ($existingVs) {
            Write-Skipped "$($existingVs.Name) is already installed; not installing another copy"
            if ($existingVs.HasGameWorkload) {
                Write-Ok '"Game development with C++" workload is present'
            }
            else {
                Write-Problem 'Add the "Game development with C++" and "Desktop development with C++" workloads:'
                Write-Problem 'Start menu -> Visual Studio Installer -> Modify -> tick both -> Modify.'
                $script:Failures.Add('Visual Studio C++ game workload')
            }
            continue
        }
    }

    foreach ($package in $Packages[$group]) {
        Install-WingetPackage $package
    }
}

# --------------------------------------------------------------------------
# 2. Windows settings
# --------------------------------------------------------------------------
if (Test-Skipped 'WindowsSettings') {
    Write-Section 'Windows settings (skipped)'
}
else {
    Write-Section 'Windows settings'
    Invoke-Change 'Developer Mode on' {
        Write-RegistryDword 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock' 'AllowDevelopmentWithoutDevLicense' 1
    }
    Invoke-Change 'Long file paths enabled (needed by Unreal and deep repos)' {
        Write-RegistryDword 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' 'LongPathsEnabled' 1
    }
    Invoke-Change 'File Explorer shows file extensions and hidden files' {
        $explorer = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Write-RegistryDword $explorer 'HideFileExt' 0
        Write-RegistryDword $explorer 'Hidden' 1
    }
    Invoke-Change "Workspace folder $Workspace" {
        New-Item -ItemType Directory -Force -Path $Workspace | Out-Null
    }
}

if (Test-Skipped 'DefenderExclusion') {
    Write-Section 'Microsoft Defender exclusion (skipped)'
}
else {
    Write-Section 'Microsoft Defender exclusion'
    # Real-time scanning of build output slows C++ and Unreal builds a lot.
    # Only your own workspace is excluded; keep downloads out of it.
    Invoke-Change "Defender does not scan $Workspace" {
        New-Item -ItemType Directory -Force -Path $Workspace | Out-Null
        try {
            Add-MpPreference -ExclusionPath $Workspace
        }
        catch {
            # Typical causes: another antivirus is active (Defender is then
            # off or passive), or the PC is managed by an organisation.
            throw ("Defender refused the exclusion ($($_.Exception.Message.Trim())). " +
                "If you use another antivirus, add $Workspace as an exclusion there. This step is optional.")
        }
    }
}

if (Test-Skipped 'PowerPlan') {
    Write-Section 'Power plan (skipped)'
}
else {
    Write-Section 'Power plan'
    Invoke-Change 'High performance power plan' {
        & powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw 'this PC does not offer the High performance plan (common on laptops); keep Balanced'
        }
    }
}

# --------------------------------------------------------------------------
# 3. Git
# --------------------------------------------------------------------------
Write-Section 'Git'
if (-not $DryRun) {
    Sync-SessionPath
}
if (-not $DryRun -and -not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Problem 'git is not available yet. Restart PowerShell and run this script again.'
    $script:Failures.Add('Git configuration')
}
else {
    if (-not $DryRun) {
        if (-not $GitName) { $GitName = Get-GitConfig 'user.name' }
        if (-not $GitName) { $GitName = Read-Host 'Your name for Git commits' }
        if (-not $GitEmail) { $GitEmail = Get-GitConfig 'user.email' }
        if (-not $GitEmail) { $GitEmail = Read-Host 'Your email for Git commits (GitHub noreply address recommended)' }
    }

    Invoke-Change "Git identity: $GitName <$GitEmail>" {
        Invoke-Git config --global user.name $GitName
        Invoke-Git config --global user.email $GitEmail
    }
    Invoke-Change 'Git defaults (main branch, long paths, prune, auto upstream, rerere)' {
        Invoke-Git config --global init.defaultBranch main
        Invoke-Git config --global core.longpaths true
        Invoke-Git config --global fetch.prune true
        Invoke-Git config --global push.autoSetupRemote true
        Invoke-Git config --global rerere.enabled true
    }
    Invoke-Change 'Git LFS for large binary assets' {
        Invoke-Git lfs install
    }
}

# --------------------------------------------------------------------------
# 4. SSH key, signed commits, GitHub
# --------------------------------------------------------------------------
if (Test-Skipped 'GitHub') {
    Write-Section 'SSH key and GitHub (skipped)'
}
else {
    Write-Section 'SSH key, signed commits and GitHub'
    $sshDir = Join-Path $HOME '.ssh'
    $keyPath = Join-Path $sshDir 'id_ed25519'
    $pubPath = "$keyPath.pub"

    Invoke-Change "SSH key at $keyPath" {
        if (Test-Path $pubPath) {
            Write-Skipped 'SSH key already exists'
            return
        }
        New-Item -ItemType Directory -Force -Path $sshDir | Out-Null
        Write-Host '    Choose a passphrase for your SSH key (recommended).'
        & (Join-Path $OpenSshDir 'ssh-keygen.exe') -t ed25519 -C $GitEmail -f $keyPath
        if ($LASTEXITCODE -ne 0) { throw 'ssh-keygen failed' }
    }

    Invoke-Change 'Windows ssh-agent running and holding the key' {
        Set-Service -Name ssh-agent -StartupType Automatic
        Start-Service -Name ssh-agent
        & (Join-Path $OpenSshDir 'ssh-add.exe') $keyPath
        if ($LASTEXITCODE -ne 0) { throw 'ssh-add failed' }
    }

    Invoke-Change 'Git uses Windows OpenSSH and signs commits with the SSH key' {
        $sshExe = (Join-Path $OpenSshDir 'ssh.exe') -replace '\\', '/'
        $keygenExe = (Join-Path $OpenSshDir 'ssh-keygen.exe') -replace '\\', '/'
        Invoke-Git config --global core.sshCommand $sshExe
        Invoke-Git config --global gpg.format ssh
        Invoke-Git config --global gpg.ssh.program $keygenExe
        Invoke-Git config --global user.signingkey ($pubPath -replace '\\', '/')
        Invoke-Git config --global commit.gpgsign true
        Invoke-Git config --global tag.gpgsign true
    }

    # A broken signing setup would make every commit fail, so prove it works
    # and roll back if it does not.
    Invoke-Change 'Signed commit test' {
        $testRepo = Join-Path $env:TEMP ('git-sign-test-' + [guid]::NewGuid().ToString('N'))
        try {
            Invoke-Git init --quiet $testRepo
            $gitOutput = (Invoke-NativeQuiet git -C $testRepo commit --quiet --allow-empty -m 'signing test') -join ' '
            if ($LASTEXITCODE -ne 0) {
                & git config --global --unset commit.gpgsign
                & git config --global --unset tag.gpgsign
                throw ("signing did not work, so commit signing was turned off again. " +
                    "Commits still work, just without the Verified badge. Git said: $gitOutput")
            }
        }
        finally {
            Remove-Item -Recurse -Force $testRepo -ErrorAction SilentlyContinue
        }
    }

    Invoke-Change 'GitHub CLI signed in (a browser window opens once)' {
        $scopes = 'admin:public_key,admin:ssh_signing_key'
        & gh auth status --hostname github.com *> $null
        if ($LASTEXITCODE -eq 0) {
            & gh auth refresh --hostname github.com --scopes $scopes
        }
        else {
            & gh auth login --hostname github.com --git-protocol ssh --web --skip-ssh-key --scopes $scopes
        }
        if ($LASTEXITCODE -ne 0) { throw 'gh auth failed' }
        & gh config set git_protocol ssh --host github.com
    }

    Invoke-Change 'SSH key registered on GitHub for sign-in and commit signing' {
        $pubKey = ((Get-Content $pubPath -Raw).Trim() -split '\s+')[0..1] -join ' '
        $title = "$env:COMPUTERNAME"

        $authKeys = @(& gh api user/keys --jq '.[].key')
        if ($authKeys -notcontains $pubKey) {
            & gh ssh-key add $pubPath --title $title --type authentication
            if ($LASTEXITCODE -ne 0) { throw 'could not add the authentication key' }
        }
        $signingKeys = @(& gh api user/ssh_signing_keys --jq '.[].key')
        if ($signingKeys -notcontains $pubKey) {
            & gh ssh-key add $pubPath --title "$title (signing)" --type signing
            if ($LASTEXITCODE -ne 0) { throw 'could not add the signing key' }
        }
    }
}

# --------------------------------------------------------------------------
# Summary
# --------------------------------------------------------------------------
Write-Section 'Done'
if ($script:Failures.Count -gt 0) {
    Write-Problem 'These steps need attention (details above and in the log):'
    $script:Failures | ForEach-Object { Write-Host "      - $_" -ForegroundColor Yellow }
}
else {
    Write-Ok 'Every step finished.'
}

Write-Host @'

Next steps by hand (not available through winget):
  - NVIDIA App, for driver updates:   https://www.nvidia.com/en-us/software/nvidia-app/
  - NVIDIA Nsight Graphics:           https://developer.nvidia.com/nsight-graphics
  - Unreal Engine: open the Epic Games Launcher -> Unreal Engine -> Library -> install.
  - Unreal source access: link GitHub to your Epic account: https://www.unrealengine.com/en-US/ue-on-github
  - Restart the computer so long paths and Visual Studio finish setting up.
'@

if (-not $DryRun) {
    Stop-Transcript | Out-Null
    Write-Host "Log: $logPath"
}
