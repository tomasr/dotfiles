
function local:Get-ShortenedPath([string]$path) {
   $loc = $path.Replace($HOME, '~')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}

function local:Get-IsAdminUser() {
   $id = [Security.Principal.WindowsIdentity]::GetCurrent()
   $p = New-Object Security.Principal.WindowsPrincipal($id)
   return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function prompt {
    # our theme
    $cdelim = [ConsoleColor]::DarkCyan
    $chost = [ConsoleColor]::Green
    $cpref = [ConsoleColor]::Cyan
    $cloc = [ConsoleColor]::DarkYellow

    if ( Get-IsAdminUser ) {
      $cpref = [ConsoleColor]::Yellow
    }
    write-host "$($env:COMPUTERNAME.ToLower())" -n -f $chost
    write-host ' | ' -n -f $cdelim
    write-host (Get-ShortenedPath (pwd).Path) -n -f $cloc
    write-host '' -f $cdelim
    write-host "$([char]0x0A7)" -n -f $cpref
    return ' '
}

