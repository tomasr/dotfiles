param( [string] $vimfile )

# some instructions we don't care for
$ignorable = ( 'link', 'clear' )

$nrx = 'hi (?<n>\w+)'
$fgrx = 'guifg=(?<n>#\w+)'
$bgrx = 'guibg=(?<n>#\w+)'
$frx = 'gui=(?<n>\S+)'

(gc $vimfile) | ?{ 
   ($_ -match $nrx) -and ($ignorable -notcontains $matches.n) 
} | %{
   if ( $matches.n -eq 'Normal' ) {
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
   # element could any combination of these
   if ( $_ -match $frx ) {
      switch ( $matches.n.split(',') ) {
         "italic" { write "   font-style: $_;" }
         "bold" { write "   font-weight: $_;" }
         "underline" { write "   text-decoration: $_;" }
      }
   }
   write '}'
}

# other boilerplate code
write 'code {'
write '   font-family: Consolas, "DejaVu Sans Mono", "Lucida Console", monospace; '
write '}'

