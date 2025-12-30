
$defaults = @{
  bg = [ConsoleColor]::Black;
  fg = [ConsoleColor]::White;
}

$rightArrow = [char]0xE0B0 # 
$rightDiagonal = [char]0xE0BC # 
$leftDiagonal = [char]0xE0B8 # 
$rightRound = [char]0xE0B4 # 
$leftRound = [char]0xE0B6 # 

$branchSymbol = [char]0xE0A0 # 
$kubeSymbol = [char]0x2388 # ⎈
$pathSymbol = [Char]::ConvertFromUtf32(0x1F5BF) # 🖿 
$hostSymbol = [char]0x0528 # Ԩ 
$promptSymbol = [char]0x03BB # λ
$lineNumber = [char]0xe0a1 # 

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

function local:Get-KubeContext {
  $kubeconfig = (Get-Content ~/.kube/config -ErrorAction SilentlyContinue | Select-String "^current-context:\s*(.+)")
  if ( $kubeconfig -ne $null ) {
    return " $kubeSymbol $($kubeconfig.Matches.Groups[1].Value) "
  }
  return ""
}

function local:Get-GitChanges {
  $diff = @(git diff --numstat)
  $added = 0
  $removed = 0
  $files = $diff.Length
  if ( $files -eq 0 ) {
    return ""
  }
  $diff | ForEach-Object {
    # output is <added> <removed> <filename>
    $match = $_ -match '(\d+)\s+(\d+)'
    $added += $matches[1]
    $removed += $matches[2]
  }

  return " ~$files $lineNumber +$added -$removed "
}

function local:Get-GitBranch {
  $branch = git rev-parse --abbrev-ref HEAD 2>&1
  if ( $LASTEXITCODE -eq 0 ) {
    $dirty = Get-GitChanges
    return " $branchSymbol $branch $dirty"
  }
  return '' 
}

function local:Get-CurrentPath() {
  $path = Get-ShortenedPath (Get-Location).Path
  $path = $path.Replace('\', '/')
  return " $pathSymbol  $path "
}

function local:Get-PromptDate() {
  return " $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') "
}

function local:Get-Hostname() {
  return " $hostSymbol $([Environment]::MachineName.ToLower()) "
}

$SEP_STYLE_NONE  = 0
$SEP_STYLE_SPACE = 1

$line1 = 
  # line 1 => history | machine | datetime | path
  @(
    @{
      bg   = [ConsoleColor]::DarkGray;
      fg   = [ConsoleColor]::White;
      text = { " {0} " -f $MyInvocation.HistoryId };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_SPACE;
    },
    @{
      bg   = [ConsoleColor]::DarkCyan;
      fg   = [ConsoleColor]::White;
      text = { Get-Hostname };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_NONE;
    },
    @{
      bg   = [ConsoleColor]::Cyan;
      fg   = [ConsoleColor]::Black;
      text = { Get-PromptDate };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_SPACE;
    },
    @{
      bg   = [ConsoleColor]::DarkBlue;
      fg   = [ConsoleColor]::White;
      text = { Get-CurrentPath };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_NONE;
    },
    @{
      bg   = [ConsoleColor]::DarkMagenta;
      fg   = [ConsoleColor]::White;
      text = { Get-GitBranch };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_SPACE;
    },
    @{
      bg   = [ConsoleColor]::DarkYellow;
      fg   = [ConsoleColor]::White;
      text = { Get-KubeContext };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_NONE;
    }
  )

$line2 =
  # Second line, prompt
  @(
    @{
      bg   = if ( Get-IsAdminUser ) { [ConsoleColor]::DarkMagenta } else { [ConsoleColor]::White };
      fg   = if ( Get-IsAdminUser ) { [ConsoleColor]::White } else { [ConsoleColor]::Black };
      text = { " $promptSymbol " };
      sep  = $rightArrow;
      sepStyle = $SEP_STYLE_NONE;
    }
  )

$promptLines = @($line1, $line2)

# Pre-compute the text for all segments of the prompt before rendering
# to avoid awkward pauses
function local:Get-ComputedLines($lines) {
  foreach ( $line in $lines ) {
    foreach ( $segment in $line ) {
      $text = Invoke-Command -ScriptBlock $segment.text
      if ( $text.Trim().Length -eq 0 ) {
        $text = ""
      }
      $segment.value = $text
    }
  }
  return $lines
}

function local:Write-PromptSegment($block, $text) {
  Write-Host -NoNewLine -BackgroundColor $block.bg -ForegroundColor $block.fg $text
}

function local:Write-PromptSeparator($leftBlock, $rightBlock, $lastInLine = $false) {
  $sep = $rightArrow
  $style = $SEP_STYLE_NONE
  if ( $leftBlock.sep -ne $null ) {
    $sep = $leftBlock.sep
    $style = $leftBlock.sepStyle
  }

  $background = (Get-Host).UI.RawUI.BackgroundColor
  if ( $style -eq $SEP_STYLE_SPACE ) {
    Write-Host $sep -NoNewLine -ForegroundColor $leftBlock.bg
    if ( !$lastInLine ) {
      Write-Host $sep -NoNewLine -BackgroundColor $rightBlock.bg -ForegroundColor $background
    }
  } else {
    Write-Host $sep -NoNewLine -ForegroundColor $leftBlock.bg -Background $rightBlock.bg
  }
}

function local:Write-PromptLineStart($symbol, $style) {
  Write-Host $symbol -NoNewLine -ForegroundColor $style.bg
}

function local:Write-PromptLine($line) {
  $previous = $null
  for ( $i = 0; $i -lt $line.Length; $i++ ) {
    $segment = $line[$i]
    $text = $segment.value
    if ( $previous -ne $null ) {
      Write-PromptSeparator $previous $segment
    } else {
      Write-PromptLineStart $leftRound $segment
    }
    Write-PromptSegment $segment $text
    $previous = $segment
  }
  Write-PromptSeparator $previous $defaults $true
}

function prompt {
  $lines = Get-ComputedLines $promptLines
  for ( $i = 0; $i -lt $lines.Length; $i++ ) {
    if ( $i -gt 0 ) {
      Write-Host "" # add new line
    }
    Write-PromptLine $lines[$i]
  }
  return ' '
}
