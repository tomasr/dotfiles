function local:Get-ShortenedPath([string]$path) {
  $loc = $path.Replace($HOME, '~')
  # remove prefix for UNC paths
  $loc = $loc -replace '^[^:]+::', ''
  # make path shorter like tabs in Vim,
  # handle paths starting with \\ and . correctly
  return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)', '\$1$2')
}

function local:Get-IsAdminUser() {
  if ( [Environment]::OSVersion.Platform -eq 'Win32NT' ) {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }
  return $false
}

function local:Write-PromptSegment($block) {
  Write-Host -NoNewLine -BackgroundColor $block.bg -ForegroundColor $block.fg (&$block.text)
}

$defaultSeparator = "$([char]0xE0B0)"

function local:Write-PromptSeparator($leftBlock, $rightBlock) {
  $sep = $defaultSeparator
  if ( $leftBlock.sep ) {
    $sep = $leftBlock.sep
  }
  Write-Host $sep -NoNewLine -BackgroundColor $rightBlock.bg -ForegroundColor $leftBlock.bg
}

$defaults = @{
  bg = [ConsoleColor]::Black;
  fg = [ConsoleColor]::White;
}

function local:Write-PromptLine($line) {
  for ( $i = 0; $i -lt $line.Length; $i++ ) {
    if ( $i -gt 0 ) {
      Write-PromptSeparator $line[$i-1] $line[$i]
    }
    Write-PromptSegment $line[$i]
  }
  Write-PromptSeparator $line[-1] $defaults
}

$promptLines = @(
  # line 1 => history | machine | path
  @(
    @{
      bg   = [ConsoleColor]::DarkGreen;
      fg   = [ConsoleColor]::White;
      text = { " {0} " -f $MyInvocation.HistoryId }
    },
    @{
      bg   = [ConsoleColor]::Green;
      fg   = [ConsoleColor]::Black;
      text = { " $([Environment]::MachineName.ToLower()) " }
    },
    @{
      bg   = [ConsoleColor]::DarkBlue;
      fg   = [ConsoleColor]::White;
      text = { " $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') " };
    },
    @{
      bg   = [ConsoleColor]::DarkCyan;
      fg   = [ConsoleColor]::White;
      text = { " $(Get-ShortenedPath (Get-Location).Path) " }
    }
  ),
  # line 2 => admin indicator, command 
  @(
    @{
      bg   = if ( Get-IsAdminUser ) { [ConsoleColor]::DarkMagenta } else { [ConsoleColor]::White };
      fg   = if ( Get-IsAdminUser ) { [ConsoleColor]::White } else { [ConsoleColor]::Black };
      text = { " $([char]0x00A7) " }
    }
  )
)

function prompt {
  for ( $i = 0; $i -lt $promptLines.Length; $i++ ) {
    if ( $i -gt 0 ) {
      Write-Host "" # add new line
    }
    Write-PromptLine $promptLines[$i]
  }
  return ' '
}
