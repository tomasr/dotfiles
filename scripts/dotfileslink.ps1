
# creates the links in $HOME to our dotfiles repo
# requires linkd.exe from the Windows Server 2003 RK
# and ln.exe from
# http://www.flexhex.com/docs/articles/hard-links.phtml

$h = $env:HOME;
ls "$h\dotfiles" | %{
   if ( $_.Name -ne '.git' ) {
      if ( test-path "$h\$($_.Name)" ) {
         if ( $_.PSIsContainer ) {
            # try to unlink first
            linkd.exe "$h\$($_.Name)" /d
         }
         rm -r -force "$h\$($_.Name)"
      }
      if ( $_.PSIsContainer ) {
         linkd.exe "$h\$($_.Name)" $_.FullName
      } else {
         fsutil hardlink create "$h\$($_.Name)" $_.FullName
      }
   }
}
Copy-Item -force (Resolve-Path "$h\dotfiles\terminal.json") (Resolve-Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json")

