
# Color palette - each color has .Fg and .Bg ANSI escape sequences
function local:NewColor([ConsoleColor]$c) {
  [PSCustomObject]@{
    Fg = $PSStyle.Foreground.FromConsoleColor($c)
    Bg = $PSStyle.Background.FromConsoleColor($c)
  }
}

$ColorBlack       = NewColor Black
$ColorWhite       = NewColor White
$ColorDarkGray    = NewColor DarkGray
$ColorDarkCyan    = NewColor DarkCyan
$ColorCyan        = NewColor Cyan
$ColorDarkBlue    = NewColor DarkBlue
$ColorDarkMagenta = NewColor DarkMagenta
$ColorDarkYellow  = NewColor DarkYellow
$reset            = $PSStyle.Reset

$defaults = @{ back = $ColorBlack; fore = $ColorWhite }

$rightArrow = [char]0xE0B0 #
$rightDiagonal = [char]0xE0BC #
$leftDiagonal = [char]0xE0B8 #
$rightRound = [char]0xE0B4 #
$leftRound = [char]0xE0B6 #

$branchSymbol = [char]0xE0A0 #
$kubeSymbol = [char]0x2388 # ⎈
$pathSymbol = [Char]::ConvertFromUtf32(0x1F5BF) # 🖿
$hostSymbol = [char]0x23FB # ⏻
$promptSymbol = [char]0x03BB # λ
$lineNumber = [char]0xe0a1 #

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
      back = $ColorDarkGray;
      fore = $ColorWhite;
      text = { " {0} " -f $MyInvocation.HistoryId };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_SPACE;
    },
    @{
      back = $ColorDarkCyan;
      fore = $ColorWhite;
      text = { Get-Hostname };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_NONE;
    },
    @{
      back = $ColorCyan;
      fore = $ColorBlack;
      text = { Get-PromptDate };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_SPACE;
    },
    @{
      back = $ColorDarkBlue;
      fore = $ColorWhite;
      text = { Get-CurrentPath };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_NONE;
    },
    @{
      back = $ColorDarkMagenta;
      fore = $ColorWhite;
      text = { Get-GitBranch };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_SPACE;
    },
    @{
      back = $ColorDarkYellow;
      fore = $ColorBlack;
      text = { Get-KubeContext };
      sep  = $rightDiagonal;
      sepStyle = $SEP_STYLE_NONE;
    }
  )

$line2 =
  # Second line, prompt
  @(
    @{
      back = if ( Get-IsAdminUser ) { $ColorDarkMagenta } else { $ColorWhite };
      fore = if ( Get-IsAdminUser ) { $ColorWhite } else { $ColorBlack };
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

function local:Format-PromptSegment($block, $text) {
  return "$($block.fore.Fg)$($block.back.Bg)$text"
}

function local:Format-PromptSeparator($leftBlock, $rightBlock, $lastInLine = $false) {
  $sep = $rightArrow
  $style = $SEP_STYLE_NONE
  if ( $leftBlock.sep -ne $null ) {
    $sep = $leftBlock.sep
    $style = $leftBlock.sepStyle
  }

  if ( $style -eq $SEP_STYLE_SPACE ) {
    $result = "$reset$($leftBlock.back.Fg)$sep"
    if ( !$lastInLine ) {
      $result += "$($rightBlock.back.Bg)$($defaults.back.Fg)$sep"
    }
    return $result
  } else {
    if ( $lastInLine ) {
      return "$reset$($leftBlock.back.Fg)$sep"
    }
    return "$($leftBlock.back.Fg)$($rightBlock.back.Bg)$sep"
  }
}

function local:Format-PromptLineStart($symbol, $style) {
  return "$reset$($style.back.Fg)$symbol"
}

function local:Format-PromptLine($line) {
  $result = ""
  $previous = $null
  for ( $i = 0; $i -lt $line.Length; $i++ ) {
    $segment = $line[$i]
    $text = $segment.value
    if ( $previous -ne $null ) {
      $result += Format-PromptSeparator $previous $segment
    } else {
      $result += Format-PromptLineStart $leftRound $segment
    }
    $result += Format-PromptSegment $segment $text
    $previous = $segment
  }
  $result += Format-PromptSeparator $previous $defaults $true
  $result += $reset
  return $result
}

function prompt {
  $lines = Get-ComputedLines $promptLines
  $result = ""
  for ( $i = 0; $i -lt $lines.Length; $i++ ) {
    if ( $i -gt 0 ) {
      $result += "`n"
    }
    $result += Format-PromptLine $lines[$i]
  }
  return "$result "
}
