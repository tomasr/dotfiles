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

function local:Write-PromptSegment($block, $text) {
  Write-Host -NoNewLine -BackgroundColor $block.bg -ForegroundColor $block.fg $text
}

$defaultSeparator = "$([char]0xE0B0)"

function local:Write-PromptSeparator($leftBlock, $rightBlock, $lastInLine = $false) {
  $background = (Get-Host).UI.RawUI.BackgroundColor
  Write-Host $defaultSeparator -NoNewLine -ForegroundColor $leftBlock.bg
  if ( !$lastInLine ) {
    Write-Host $defaultSeparator -NoNewLine -BackgroundColor $rightBlock.bg -ForegroundColor $background
  }
}

$defaults = @{
  bg = [ConsoleColor]::Black;
  fg = [ConsoleColor]::White;
}

function local:Write-PromptLine($line) {
  $previous = $null
  for ( $i = 0; $i -lt $line.Length; $i++ ) {
    $text = &$line[$i].text
    if ( $text.Trim().Length -gt 0 ) {
      if ( $previous -ne $null ) {
        Write-PromptSeparator $previous $line[$i]
      }
      Write-PromptSegment $line[$i] $text
      $previous = $line[$i]
    }
  }
  Write-PromptSeparator $previous $defaults $true
}

function local:Get-KubeContext {
  $kubeconfig = (Get-Content ~/.kube/config -ErrorAction SilentlyContinue | Select-String "^current-context:\s*(.+)")
  if ( $kubeconfig -ne $null ) {
    return "$([char]0x416) $($kubeconfig.Matches.Groups[1].Value)"
  }
  return $null
}

function Get-FirstLine() {
  # line 1 => history | machine | datetime | path
  $line = @(
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
    },
    @{
      bg   = [ConsoleColor]::DarkGreen;
      fg   = [ConsoleColor]::White;
      text = { " $(Get-KubeContext) " }
    }
  )
  return $line
}

function Get-SecondLine() {
  # line 2 => admin indicator, command
  return @(
    @{
      bg   = if ( Get-IsAdminUser ) { [ConsoleColor]::DarkMagenta } else { [ConsoleColor]::White };
      fg   = if ( Get-IsAdminUser ) { [ConsoleColor]::White } else { [ConsoleColor]::Black };
      text = { " $([char]0x00A7) " }
    }
  )
}

$promptLines = @(
  @(Get-FirstLine),
  @(Get-SecondLine)
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
