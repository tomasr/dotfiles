###############################################################################
# powershell initialization script
# call from profile.ps1, like this:
#     . "$env:HOME\.profile.ps1"
# (notice the '.')
###############################################################################

#
# Set the $HOME variable for our use
# and make powershell recognize ~\ as $HOME
# in paths
#
set-variable -name HOME -value (resolve-path $env:Home).Path -force
(get-psprovider FileSystem).Home = $HOME

#
# global variables and core env variables
#
$HOME_ROOT = [IO.Path]::GetPathRoot($HOME)
$TOOLS = Join-Path $HOME_ROOT "tools"
$SCRIPTS = Join-Path "$HOME" "scripts"
$env:EDITOR = 'nvim'

#
# set path to include my usual directories
# and configure dev environment
#
function script:Append-Path([string] $path ) {
  if ( (-not [string]::IsNullOrEmpty($path)) -and (test-path $path)  ) {
    $parts = $env:PATH.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)
    if ( $paths -notcontains $path ) {
      $parts += $path
      $env:PATH = $parts -join ';'
    }
  }
}


append-path "$TOOLS"

$env:PATH -split ';'

Import-Module ~/scripts/DevEnvironment
Set-DevEnvironmentAny

. ~/scripts/Set-Prompt.ps1

Import-Module ~/scripts/ProfileUtils.psm1 -Scope Global

if ($IsWindows) {
  . ~/scripts/Set-WindowsProfile.ps1
  $env:TERM = 'xterm-256color'
}
