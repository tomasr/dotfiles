
Set-Alias -Name mco -Value "${env:PROGRAMFILES}\Midnight Commander\mc.exe"

function Install-Apps($sourceList) {
  $lines = Get-Content $sourceList
  $lines | ForEach-Object {
    winget install --id=$_ -e
  }
}
