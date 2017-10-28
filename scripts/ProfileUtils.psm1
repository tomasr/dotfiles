function ConvertTo-Hex([long] $dec) {
   return "0x" + $dec.ToString("X")
}

function Get-NewGuid {
   [guid]::NewGuid().ToString('d')
}

New-Alias uuidgen Get-NewGuid

function Get-Syntax([string] $cmdlet) {
   get-command $cmdlet -syntax
}

function ConvertTo-BinHex($array) {
   $str = new-object system.text.stringbuilder
   $array | %{
      [void]$str.Append($_.ToString('x2'));
   }
   return $str.ToString()
}

function ConvertFrom-BinHex([string]$binhex) {
   $arr = new-object byte[] ($binhex.Length/2)
   for ( $i=0; $i -lt $arr.Length; $i++ ) {
      $arr[$i] = [Convert]::ToByte($binhex.substring($i*2,2), 16)
   }
   return $arr
}
function Get-Hash($value, $hashalgo = 'MD5') {
   $tohash = $value
   if ( $value -is [string] ) {
      $tohash = [text.encoding]::UTF8.GetBytes($value)
   }
   $hash = [security.cryptography.hashalgorithm]::Create($hashalgo)
   return convert-tobinhex($hash.ComputeHash($tohash));
}

function ConvertTo-BinLe([long]$val) {
   [Convert]::ToString($val, 2)
}

function script:byteToChar([byte]$b) {
   if ( $b -lt 32 -or $b  -gt 127 ) {
      '.'
   } else {
      [char]$b
   }
}
function Format-Bytes($bytes, $bytesPerLine = 8) {
   $buffer = new-object system.text.stringbuilder
   for ( $offset=0; $offset -lt $bytes.Length; $offset += $bytesPerLine ) {
      [void]$buffer.AppendFormat('{0:X8}   ', $offset)
      $numBytes = [math]::min($bytesPerLine, $bytes.Length - $offset)
      for ( $i=0; $i -lt $numBytes; $i++ ) {
         [void]$buffer.AppendFormat('{0:X2} ', $bytes[$offset+$i])
      }
      [void]$buffer.Append(' ' *((($bytesPerLine - $numBytes)*3)+3))
      for ( $i=0; $i -lt $numBytes; $i++ ) {
         [void]$buffer.Append( (byteToChar $bytes[$offset + $i]) )
      }
      [void]$buffer.Append("`n")
   }
   $buffer.ToString()
}
function ConvertFrom-Base64([string] $str) {
   [convert]::FromBase64String($str)
}

# SID mapping functions
function Resolve-SID($stringSid) {
  $objSID = New-Object System.Security.Principal.SecurityIdentifier($stringSid) 
  $objUser = $objSID.Translate([System.Security.Principal.NTAccount]) 
  $objUser.Value
}
function Resolve-User($user) {
  $objUser = New-Object System.Security.Principal.NTAccount($user) 
  $objSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]) 
  $objSID.Value
}
function Get-SIDHash([String]$sidPrefix, [String]$user) {
  $userToHash = switch ( $sidPrefix ) {
    'S-1-5-82' { $user.ToLower() }
    default { $user.ToUpper() }
  }
  $userBytes = [Text.Encoding]::Unicode.GetBytes($userToHash)
  $hash = Convert-FromBinHex (Get-Hash $userBytes 'SHA1')
  $sid = $sidPrefix
  for ( $i=0; $i -lt 5; $i++ ) {
    $sid += '-' + [BitConverter]::ToUInt32($hash, $i*4)
  }
  $sid
}