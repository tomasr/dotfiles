###############################################################################
# Configures the .NET / Visual Studio / Windows SDK
# Build environment. Loosely based on the SDK batch files.
#
# First it will try to set up the environment for .NET 3.5
# and VS2008. Failing that, falls back to .NET 3.0/VS2005.
###############################################################################

$NETFXDIR = "$env:WINDIR\Microsoft.NET\Framework"
$FX20 = "$NETFXDIR\v2.0.50727"
$FX35 = "$NETFXDIR\v3.5"

function script:append-path { 
   $env:PATH += ';' + $args
}
function script:append-lib {
   if ( test-path('Env:\LIB') ) {
      $env:LIB += ';' + $args
   } else {
      $env:LIB = $args
   }
}
function script:append-include { 
   if ( test-path('Env:\INCLUDE') ) {
      $env:INCLUDE += ';' + $args
   } else {
      $env:INCLUDE = $args
   }
}
function script:get-vsdir([string] $version) {
   $regpath = "HKLM:SOFTWARE\Microsoft\VisualStudio\$version"
   if ( test-path($regpath) ) {
      $regKey = get-itemproperty $regpath
      return $regkey.InstallDir
   }
   return $null
}
function script:set-vsenv([string] $version) {
   $VSDIR = (get-vsdir $version)
   if ( $VSDIR -ne $null ) {
      append-path $VSDIR
      append-path "$VSDIR..\..\VC\bin"
      append-path "$VSDIR..\Tools"

      append-include "$VSDIR..\..\VC\include"
      append-lib "$VSDIR..\..\VC\lib"
      return $true
   }
   return $false
}
function script:get-psdkdir {
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
function script:set-psdkenv {
   $sdkdir = (get-psdkdir)
   if ( ($sdkdir -ne $null) -and (test-path $sdkdir) ) {
      append-path "$sdkdir\bin"
      if ( test-path "$sdkdir\include" ) { 
         append-include "$sdkdir\include" 
      }
      if ( test-path "$sdkdir\lib" ) {
         append-lib "$sdkdir\lib"
      }
   }
}

set-psdkenv
# if .NET 3.5 is installed, default to that, otherwise use 2.0
if ( test-path($FX35) ) {
   append-path $FX35
}
append-path $FX20
[void] (set-vsenv "9.0")
[void] (set-vsenv "8.0")



