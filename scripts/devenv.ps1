###############################################################################
# Configures the .NET / Visual Studio / Windows SDK
# Build environment. Loosely based on the SDK batch files.
#
# First it will try to set up the environment for .NET 3.5
# and VS2008. Failing that, falls back to .NET 3.0/VS2005.
###############################################################################

$global:NETFXDIR = "$env:WINDIR\Microsoft.NET\Framework"
$global:FX20 = "$NETFXDIR\v2.0.50727"
$global:FX35 = "$NETFXDIR\v3.5"
$global:LIBDIRS = @()
$global:DEVPATHS = @()
$global:INCDIRS = @()


function add-path {
   $global:DEVPATHS = $global:DEVPATHS + $args
}
function append-lib {
   $global:LIBDIRS = $global:LIBDIRS + $args
}
function append-include {
   $global:INCDIRS = $global:INCDIRS + $args
}
function get-vsdir([string] $version) {
   $regpath = "HKLM:SOFTWARE\Microsoft\VisualStudio\$version"
   if ( test-path($regpath) ) {
      $regKey = get-itemproperty $regpath
      return $regkey.InstallDir
   }
   return $null
}
function set-vsenv([string] $version) {
   $VSDIR = (get-vsdir $version)
   if ( $VSDIR -ne $null ) {
      add-path $VSDIR
      add-path "$VSDIR..\..\VC\bin"
      add-path "$VSDIR..\Tools"

      append-include "$VSDIR..\..\VC\include"
      append-lib "$VSDIR..\..\VC\lib"
      return $true
   }
   return $false
}
function get-psdkdir {
   $regpath = "HKLM:SOFTWARE\Microsoft\Microsoft SDKs\Windows\"
   if ( test-path($regpath) ) {
      $regKey = get-itemproperty $regpath
      return $regkey.CurrentInstallFolder
   }
   # try the .NET framework SDK
   $regpath = "HKLM:SOFTWARE\Microsoft\Microsoft SDKs\.NETFramework\v2.0"
   if ( test-path($regpath) ) {
      $regKey = get-itemproperty $regpath
      return $regkey.InstallationFolder
   }
   return $null
}
function set-psdkenv {
   $sdkdir = (get-psdkdir)
   if ( ($sdkdir -ne $null) -and (test-path $sdkdir) ) {
      add-path "$sdkdir\bin"
      if ( test-path "$sdkdir\include" ) { 
         append-include "$sdkdir\include" 
      }
      if ( test-path "$sdkdir\lib" ) {
         append-lib "$sdkdir\lib"
      }
   }
}
function script:join($values) {
   [string]::join(';', $values)
}

function set-devenv($vsVersion, $sdkVersion) {
   if ( $sdkVersion -ne $null ) {
      [void] (set-psdkenv $sdkVersion)
   }
   if ( $vsVersion -ne $null ) {
      [void] (set-vsenv $vsVersion)
   }
}

#set-devenv '' 'v6.0A'
set-psdkenv
# if .NET 3.5 is installed, default to that, otherwise use 2.0
if ( test-path($FX35) ) {
   add-path $FX35
}
add-path $FX20
[void] (set-vsenv "9.0")
[void] (set-vsenv "8.0")

$env:LIB = join($global:LIBDIRS)
$env:INCLUDE = join($global:INCDIRS)
$env:PATH = $env:PATH + ';' + (join($global:DEVPATHS))

