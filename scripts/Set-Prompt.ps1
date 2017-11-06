function local:Get-ShortenedPath([string]$path) {
   $loc = $path.Replace($HOME, '~')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}

function local:Get-IsAdminUser() {
   if ( [Environment]::OSVersion.Platform -eq 'Win32NT' ) {
     $id = [Security.Principal.WindowsIdentity]::GetCurrent()
     $p = New-Object Security.Principal.WindowsPrincipal($id)
     return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
   }
   return $false
}

function local:Add-Block($block) {
  Write-Host -NoNewLine -BackgroundColor $block.bg -ForegroundColor $block.fg (&$block.text)
}

function local:Add-Separator($leftBlock, $rightBlock) {
  Write-Host "$([char]0xE0B0)" -NoNewLine -BackgroundColor $rightBlock.bg -ForegroundColor $leftBlock.bg
}

$defaults = @{
  bg = [ConsoleColor]::Black;
  fg = [ConsoleColor]::White;
}

$historyBlock = @{
  bg = [ConsoleColor]::DarkGreen;
  fg = [ConsoleColor]::White;
  text = { " {0} "-f $MyInvocation.HistoryId }
}

$hostBlock = @{
  bg = [ConsoleColor]::Green;
  fg = [ConsoleColor]::Black;
  text = { " $([Environment]::MachineName.ToLower()) " }
}

$pathBlock = @{
  bg = [ConsoleColor]::DarkCyan;
  fg = [ConsoleColor]::White;
  text = { " $(Get-ShortenedPath (pwd).Path) " }
}

$cmdBlock = @{
  bg = if ( Get-IsAdminUser ) { [ConsoleColor]::Magenta } else { [ConsoleColor]::White };
  fg = [ConsoleColor]::Black;
  text = { " $([char]0x0A7) " }
}

function prompt {
    Add-Block $historyBlock
    Add-Separator $historyBlock $hostBlock
    Add-Block $hostBlock
    Add-Separator $hostBlock $pathBlock
    Add-Block $pathBlock
    Add-Separator $pathBlock $defaults

    Write-Host ""

    Add-Block $cmdBlock
    Add-Separator $cmdBlock $defaults
    return ' '
}

