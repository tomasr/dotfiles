param( [string] $vimfile )

(gc $vimfile) | %{
   $nrx = "hi (?<n>\w+)"
   $fgrx = "guifg=(?<n>#\w+)"
   $bgrx = "guibg=(?<n>#\w+)"
   $frx = "gui=(?<n>\w+)"

   $isDef = $false
   if ( $_ -match $nrx ) {
      if ( $matches.n -eq 'Normal' ) {
         $isDef = true;
         write '.codebg {'
         write '   border-left: solid 1em #303030;'
         write '   font-size: 1.1em;'
         write '   padding: 0.8em 0.5em;'
      } else {
         write ".$($matches.n) {"
      }
      if ( $_ -match $fgrx ) {
         write "   color: $($matches.n);"
      }
      if ( $_ -match $bgrx ) {
         write "   background: $($matches.n);"
      }
      if ( $_ -match $frx ) {
         if ( $matches.n.indexOf("italic") -ge 0 ) {
            write "   font-style: italic;"
         }
         if ( $matches.n.indexOf("bold") -ge 0 ) {
            write "   font-weight: bold;"
         }
      }
      write "}"
   }
}

# write the boilerplate part
write "code {"
write "   font-family: Consolas, `"DejaVu Sans Mono`", `"Lucida Console`", monospace; "
write "}"

