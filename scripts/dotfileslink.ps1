
# creates the links in $HOME to our dotfiles repo
# requires ln.exe and rj.exe from 
# http://www.flexhex.com/docs/articles/hard-links.phtml

ls ~\dotfiles | %{
   if ( $_.Name -ne '.git' ) {
      if ( test-path "~\$($_.Name)" ) {
         if ( $_.PSIsContainer ) {
            # try to unlink first
            rj.exe "$HOME\$($_.Name)"
         }
         rm -r -force "~\$($_.Name)"
      }
      ln.exe $_.FullName "$HOME\$($_.Name)"
   }
}
