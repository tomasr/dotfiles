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
set-variable -name HOME -value (resolve-path $env:Home) -force
(get-psprovider FileSystem).Home = $HOME

#
# global variables and core env variables
#
$HOME_ROOT = [IO.Path]::GetPathRoot($HOME)
$TOOLS = "$HOME_ROOT\tools"
$SCRIPTS = "$HOME\scripts"
$env:EDITOR = 'gvim.exe'

#
# set path to include my usual directories
# and configure dev environment
#
function script:Append-Path([string] $path ) {
   if ( -not [string]::IsNullOrEmpty($path) ) {
      if ( (test-path $path) -and (-not $env:PATH.contains($path)) ) {
         $env:PATH += ';' + $path
      }
   }
}


append-path "$TOOLS"
append-path "$TOOLS\vim"
append-path "$($env:WINDIR)\system32\inetsrv"

Import-Module ~/scripts/DevEnvironment
Set-DevEnvironment 15

. ~/scripts/Set-Prompt.ps1

Import-Module ~/scripts/ProfileUtils.psm1 -Scope Global