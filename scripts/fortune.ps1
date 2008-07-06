
$wc = new-object net.webclient
$js = $wc.DownloadString('http://www.quotedb.com/quote/quote.php?action=random_quote&=&=&')

function strip-html([string] $str) {
   $val = $str -replace '<[^>]+>', ''
   $val = $val -replace '`', "'"
   $val = $val -replace "''", '"'
   return $val
}

function next-word([string] $text, [int] $start) {
   $end = $start
   for ( ; $end -lt $text.Length; $end += 1 ) {
      if ( $text[$end] -eq ' ' ) {
         break
      }
   }
   return $text.Substring($start, $end - $start)
}

function wrap-text([string] $text) {
   $buf = new-object Text.StringBuilder
   $lnl = $host.UI.RawUI.WindowSize.Width - 2
   $pos = 0
   $linepos = 0
   while ( $pos -lt $text.Length ) {
      $word = (next-word $text $pos)
      if ( $linepos + $word.Length -gt $lnl ) {
         [void] $buf.Append("`n")
         $linepos = 0
      } 
      [void] $buf.Append($word + ' ')
      $pos += $word.Length + 1
      $linepos += $word.Length + 1
   }
   write $buf.ToString()
}


if ( $js -ne $null ) {
   $js = $js.trim()
   $p1 = "^.+'(?<text>.+)<br>'\);"
   $p2 = '">(?<author>.+)</a>'

   $authorline = $js.Substring($js.LastIndexOf("`n"))
   $maintext = $js.Substring(0, $js.LastIndexOf("`n"))
   if ( $maintext -match $p1 ) {
      $matches.text.Split("`n") | %{ 
         wrap-text (strip-html $_) 
      }
   }
   if ( $authorline -match $p2 ) {
      write-host "`t`t-- $($matches.author)" -f DarkGreen
   }
}

