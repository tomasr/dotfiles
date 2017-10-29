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
    $pbg = [ConsoleColor]::Cyan
    $pfg = [ConsoleColor]::DarkCyan

    if ( Get-IsAdminUser ) {
      $pbg = [ConsoleColor]::DarkYellow
      $pfg = [ConsoleColor]::White
    }
    Write-Host " $($env:COMPUTERNAME.ToLower()) " -NoNewline -BackgroundColor 'Green' -ForegroundColor 'Black'
    Write-Host "$([char]0xE0B0)" -NoNewLine -BackgroundColor 'DarkCyan' -ForegroundColor 'Green'
    Write-Host " $(Get-ShortenedPath (pwd).Path) " -NoNewLine -BackgroundColor 'DarkCyan' -ForegroundColor 'White' 
    Write-Host "$([char]0xE0B0)" -ForegroundColor 'DarkCyan'

    write-host " $([char]0x0A7) " -NoNewLine -BackgroundColor $pbg -ForegroundColor $pfg
    write-host "$([char]0xE0B0)" -NoNewLine -ForegroundColor $pbg
    return ' '
}

