
# creates the links in $HOME to our dotfiles repo
# requires linkd.exe from the Windows Server 2003 RK
# and ln.exe from
# http://www.flexhex.com/docs/articles/hard-links.phtml

ls ~\dotfiles | %{
   if ( $_.Name -ne '.git' ) {
      if ( test-path "~\$($_.Name)" ) {
         if ( $_.PSIsContainer ) {
            # try to unlink first
            linkd.exe "$HOME\$($_.Name)" /d
         }
         rm -r -force "~\$($_.Name)"
      }
      if ( $_.PSIsContainer ) {
         linkd.exe "$HOME\$($_.Name)" $_.FullName
      } else {
         ln.exe $_.FullName "$HOME\$($_.Name)"
      }
   }
}
