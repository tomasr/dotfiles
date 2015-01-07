param([string]$xcodeFile)

function ctoi([float]$x) {
   [int]($x*255)
}
function itoh([int]$x) {
   $x.ToString('X2')
}
function colorToHex([string]$colorDef) {
   ($r, $g, $b) = $colorDef -split ' '
   ($r, $g, $b) = (ctoi $r), (ctoi $g), (ctoi $b)
   "#$(itoh $r)$(itoh $g)$(itoh $b)"
}

$xml = [xml](gc $xcodeFile)
$colors = $xml.SelectSingleNode("/plist/dict[key='Colors']/dict")

$i = 0
$colors.key | %{
   $name = $_
   $colorDef = colorToHex $colors.string[$i]
   $i++
   "$name = $colorDef"
}


