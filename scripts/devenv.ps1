###############################################################################
# Configures the .NET / Visual Studio / Windows SDK
# Build environment. Loosely based on the SDK batch files.
#
# First it will try to set up the environment for .NET 3.5
# and VS2008. Failing that, falls back to .NET 3.0/VS2005.
###############################################################################

param([string]$version = 'vs2010')

$oldEnv = @{ }
if ( test-path variable:'global:PSDEVENV' ) {
  $oldEnv = $global:PSDEVENV
}

function Prepend-IfExists {
  PARAM(
      [string] $newPath,
      [string] $envVar = "PATH"
    )
  $envPath = ("Env:\" + $envVar)
  $oldPath = get-content $envPath -ea:SilentlyContinue
  if ( $newPath -ne $null ) {
    if ( $oldPath -ne $null ) { $newPath = $newPath + ";" + $oldPath }
    set-content $envPath $newPath
  }
}

#
# clean up the environment from the previous values set
#
if ( $oldEnv.Keys.Count -gt 0 ) {
  $oldEnv.Keys | %{
    $value = get-content "Env:\$_"
    if ( $value -ne $null ) {
      $value = $value.Replace($oldEnv[$_] + ';', '')
      set-content "Env:\$_" $value
    }
  }
}

$newEnv = @{ }
if ( -not [String]::IsNullOrEmpty($version) ) {
  $newEnv = & "$SCRIPTS\$version.ps1"
}

if ( $newEnv.Keys.Count -gt 0 ) {
  $newEnv.Keys | %{
    Prepend-IfExists $newEnv[$_] $_
  }
}
$global:PSDEVENV = $newEnv
