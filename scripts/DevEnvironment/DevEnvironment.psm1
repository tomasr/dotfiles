function Get-ProgramFiles32
{
  if ( [IntPtr]::Size -eq 8 ) {
    return ${env:ProgramFiles(X86)}
  } else {
    return $env:ProgramFiles
  }
}

function Get-Arch()
{
  if ( [IntPtr]::Size -eq 8 )
  {
    return "-arch=amd64"
  }
  return "-arch=x86"
}

# This method will execute a batch file and then put the resulting 
# environment into the current context 
function Import-Environment() {
    param ( $file = $(throw "Need a CMD/BAT file to execute"),
            $argv = "") 

	if ([System.IO.File]::Exists($file)) {
		$tempFile = [IO.Path]::GetTempFileName()

		# Store the output of cmd.exe.  We also ask cmd.exe to output
		# the environment table after the batch file completes

		cmd /c " `"$file`" $argv && set > `"$tempFile`" "

		## Go through the environment variables in the temp file.
		## For each of them, set the variable in our local environment.
		remove-item -path env:*
		Get-Content $tempFile | Foreach-Object {
			if($_ -match "^(.*?)=(.*)$") {
				$n = $matches[1]
				if ($n -eq "prompt") {
					# Ignore: Setting the prompt environment variable has no
					#         connection to the PowerShell prompt
				} elseif ($n -eq "title") {
					$host.ui.rawui.windowtitle = $matches[2];
					set-item -path "env:$n" -value $matches[2];
				} else {
					set-item -path "env:$n" -value $matches[2];
				}
			}
		}
		Remove-Item $tempFile
    }
}


$vsVersions = @(
  @{ Version = 18; Path = Join-Path $env:ProgramFiles "Microsoft Visual Studio\18\*\Common7\Tools\VsDevCmd.bat" },
  @{ Version = 17; Path = Join-Path $env:ProgramFiles "Microsoft Visual Studio\2022\*\Common7\Tools\VsDevCmd.bat" },
  @{ Version = 16; Path = Join-Path (Get-ProgramFiles32) "Microsoft Visual Studio\2019\*\Common7\Tools\VsDevCmd.bat"; },
  @{ Version = 15; Path = Join-Path (Get-ProgramFiles32) "Microsoft Visual Studio\2017\*\Common7\Tools\VsDevCmd.bat"; }
)

function Set-DevEnvironmentAny() {
  foreach ( $vs in $vsVersions ) {
    $path = Resolve-Path $vs.Path -ErrorAction SilentlyContinue
    if ( ($path -ne $null) -and (Test-Path $path) ) {
      . Import-Environment $path
      return;
    }
  }
  throw "No supported VS versions found"
}

function Set-DevEnvironment() {
    param ( [string]$version = $(throw "Need a VS version"))

    $arch = Get-Arch

    if ( $version -eq 15 ) {
        $vsPath = Join-Path (Get-ProgramFiles32) "Microsoft Visual Studio\2017\*\Common7\Tools\VsDevCmd.bat"
        . Import-Environment (resolve-path $vsPath)
    } elseif ( $version -eq 16 ) {
        $vsPath = Join-Path (Get-ProgramFiles32) "Microsoft Visual Studio\2019\*\Common7\Tools\VsDevCmd.bat"
        . Import-Environment (resolve-path $vsPath)
    } elseif ( $version -eq 17 ) {
        $vsPath = Join-Path $env:ProgramFiles "Microsoft Visual Studio\2022\*\Common7\Tools\VsDevCmd.bat"
        . Import-Environment -file (resolve-path $vsPath) -argv $arch
    } elseif ( $version -eq 18 ) {
        $vsPath = Join-Path $env:ProgramFiles "Microsoft Visual Studio\18\*\Common7\Tools\VsDevCmd.bat"
        . Import-Environment -file (resolve-path $vsPath) -argv $arch
    } else {
        $vsPath = "Microsoft Visual Studio $version.0\VC\vcvarsall.bat"
        $target = join-path (Get-ProgramFiles32) $vsPath
        . Import-Environment $target
    }
}

