param([string]$puttyConf)

$sessionKey = "HKCU:\Software\SimonTatham\PuTTY\Sessions\$puttyConf"
if ( test-path $sessionKey ) {
   $values = @{
      "Xterm256Colour" = 0x00000001
      "BoldAsColour" = 0x00000001
      "Colour0" = "187,187,187"
      "Colour1" = "255,255,255"
      "Colour2" = "8,8,8"
      "Colour3" = "85,85,85"
      "Colour4" = "0,0,0"
      "Colour5" = "0,255,0"
      "Colour6" = "46,52,54"
      "Colour7" = "85,87,83"
      "Colour8" = "204,0,0"
      "Colour9" = "239,41,41"
      "Colour10" = "78,154,6"
      "Colour11" = "138,226,52"
      "Colour12" = "196,160,0"
      "Colour13" = "252,233,79"
      "Colour14" = "52,101,164"
      "Colour15" = "114,159,207"
      "Colour16" = "117,80,123"
      "Colour17" = "173,127,168"
      "Colour18" = "6,152,154"
      "Colour19" = "52,226,226"
      "Colour20" = "211,215,207"
      "Colour21" = "238,238,236"
   }
   $values.Keys | %{
      set-itemproperty $sessionKey $_ $values[$_]
   }
} else {
   write-error "Profile '$puttyConf' does not exist in the Putty configuration"
}

