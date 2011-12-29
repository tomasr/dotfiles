# by Brad Wilson
$_env = @{ }
$VS2008Key = $null

if (test-path HKLM:SOFTWARE\Wow6432Node\Microsoft\VisualStudio\9.0) {
  $VS2008Key = get-itemproperty HKLM:SOFTWARE\Wow6432Node\Microsoft\VisualStudio\9.0
}
else {
  if (test-path HKLM:SOFTWARE\Microsoft\VisualStudio\9.0) {
    $VS2008Key = get-itemproperty HKLM:SOFTWARE\Microsoft\VisualStudio\9.0
  }
}

if ($VS2008Key -ne $null) {
  $vsPath = split-path $VS2008Key.InstallDir -Parent | split-path -Parent
  $vcPath = join-path $vsPath "VC"

  if (test-path $vsPath) {
    write-host "Setting environment for Microsoft Visual Studio 2008."

    # Determine installation directory of Platform SDK

    $WindowsSdkDir = $null

    if (test-path "HKLM:SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows") {
      $WindowsSdkDir = (get-itemproperty "HKLM:SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows").CurrentInstallFolder
    }
    else {
      if (test-path "HKLM:SOFTWARE\Microsoft\Microsoft SDKs\Windows") {
        $WindowsSdkDir = (get-itemproperty "HKLM:SOFTWARE\Microsoft\Microsoft SDKs\Windows").CurrentInstallFolder
      }
      else {
        if (test-path "HKCU:SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows") {
            $WindowsSdkDir = (get-itemproperty "HKCU:SOFTWARE\Wow6432Node\Microsoft\Microsoft SDKs\Windows").CurrentInstallFolder
        }
        else {
          if (test-path "HKCU:SOFTWARE\Microsoft\Microsoft SDKs\Windows") {
            $WindowsSdkDir = (get-itemproperty "HKCU:SOFTWARE\Microsoft\Microsoft SDKs\Windows").CurrentInstallFolder
          }
          else {
            $WindowsSdkDir = join-path $vcPath "PlatformSDK"
          }
        }
      }
    }

    $FrameworkKey = get-itemproperty HKLM:SOFTWARE\Microsoft\.NETFramework
    $_env['FrameworkDir'] = $FrameworkKey.InstallRoot
    $_env['FrameworkVersion'] = $VS2008Key."CLR Version"
    $_env['Framework35Version'] = "v3.5"

    $_env['DevEnvDir'] = $VS2008Key.InstallDir

    # PATH environment settings

    $paths = @()
    $paths += $env:DevEnvDir
    $paths += join-path $vcPath "BIN"
    $paths += join-path $vsPath "Common7\Tools"
    $paths += join-path $_env['FrameworkDir'] $env:Framework35Version
    $paths += join-path $_env['FrameworkDir'] $env:FrameworkVersion
    $paths += join-path $vcPath "VCPackages"
    if (test-path (join-path $WindowsSdkDir "bin"))
    { $paths += join-path $WindowsSdkDir "bin" }

    $pathText = [string]::Join(";",$paths)
    $_env['PATH'] = $pathText

    # INCLUDE environment settings

    $includes = @()

    if (test-path (join-path $vcPath "atlmfc\include"))
    { $includes += join-path $vcPath "atlmfc\include" }
    if (test-path (join-path $vcPath "include"))
    { $includes += join-path $vcPath "include" }
    if (test-path (join-path $WindowsSdkDir "include"))
    { $includes += join-path $WindowsSdkDir "include" }

    if ($includes.Count -gt 0)
    {
      $includeText = [string]::Join(";",$includes)
      $_env['INCLUDE'] = $includeText
    }

    # LIB environment settings

    $libs = @()

    if (test-path (join-path $vcPath "atlmfc\lib"))
    { $libs += join-path $vcPath "atlmfc\lib" }
    if (test-path (join-path $vcPath "lib"))
    { $libs += join-path $vcPath "lib" }
    if (test-path (join-path $WindowsSdkDir "lib"))
    { $libs += join-path $WindowsSdkDir "lib" }

    if ($libs.Count -gt 0)
    {
      $libText = [string]::Join(";",$libs)
      $_env['LIB'] = $libText
    }

    # LIBPATH environment settings

    $libpaths = @()

    $libpaths += join-path $_env['FrameworkDir'] $_env['Framework35Version']
    $libpaths += join-path $_env['FrameworkDir'] $_env['FrameworkVersion']
    if (test-path (join-path $vcPath "atlmfc\lib"))
    { $libpaths += join-path $vcPath "atlmfc\lib" }
    if (test-path (join-path $vcPath "lib"))
    { $libpaths += join-path $vcPath "lib" }

    $libpathsText = [string]::Join(";",$libpaths)
    $_env['LIBPATH'] = $libpathsText

    $_env['VSINSTALLDIR'] = $vsPath
    $_env['VCINSTALLDIR'] = $vcPath
    $_env['WINDOWSSDKDIR'] = $WindowsSdkDir
  }
  else {
    write-error "Couldn't find the Visual Studio 2008 installation directory."
  }
}

return $_env

