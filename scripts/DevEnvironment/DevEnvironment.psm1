function Get-ProgramFiles32
{
  if ( [IntPtr]::Size -eq 8 ) {
    return ${env:ProgramFiles(X86)}
  } else {
    return $env:ProgramFiles
  }
}

# This method will execute a batch file and then put the resulting 
# environment into the current context 
function Import-Environment() {
    param ( $file = $(throw "Need a CMD/BAT file to execute"),
            $args = "") 

    $tempFile = [IO.Path]::GetTempFileName()

    # Store the output of cmd.exe.  We also ask cmd.exe to output
    # the environment table after the batch file completes

    cmd /c " `"$file`" $args && set > `"$tempFile`" "

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

function Set-DevEnvironment() {
    param ( [string]$version = $(throw "Need a VS version"))

    if ( $version -eq 15 ) {
        $vsPath = Join-Path (Get-ProgramFiles32) "Microsoft Visual Studio\2017\*\Common7\Tools\VsDevCmd.bat"
        . Import-Environment (resolve-path $vsPath)
    } else {
        $vsPath = "Microsoft Visual Studio $version.0\VC\vcvarsall.bat"
        $target = join-path (Get-ProgramFiles32) $vsPath
        . Import-Environment $target
    }
}

