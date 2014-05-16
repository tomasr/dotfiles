###############################################################################
# powershell initialization script
# call from profile.ps1, like this:
#     . "$env:HOME\.profile.ps1"
# (notice the '.')
###############################################################################

#
# Set the $HOME variable for our use
# and make powershell recognize ~\ as $HOME
# in paths
#
set-variable -name HOME -value (resolve-path $env:Home) -force
(get-psprovider FileSystem).Home = $HOME

#
# global variables and core env variables
#
$HOME_ROOT = [IO.Path]::GetPathRoot($HOME)
$TOOLS = "$HOME_ROOT\tools"
$SCRIPTS = "$HOME\scripts"
$env:EDITOR = 'gvim.exe'

#
# set path to include my usual directories
# and configure dev environment
#
function script:append-path([string] $path ) {
   if ( -not [string]::IsNullOrEmpty($path) ) {
      if ( (test-path $path) -and (-not $env:PATH.contains($path)) ) {
         $env:PATH += ';' + $path
      }
   }
}


append-path "$TOOLS"
append-path (resolve-path "$TOOLS\svn-*")
append-path (resolve-path "$TOOLS\nant-*")
append-path "$TOOLS\vim"
append-path "$TOOLS\gnu"
append-path "$TOOLS\git\bin"
append-path "$($env:WINDIR)\system32\inetsrv"

& "$SCRIPTS\devenv.ps1" 'vs2010'
& "$SCRIPTS\javaenv.ps1"

#
# Define our prompt. Show '~' instead of $HOME
#
function shorten-path([string] $path) {
   $loc = $path.Replace($HOME, '~')
   # remove prefix for UNC paths
   $loc = $loc -replace '^[^:]+::', ''
   # make path shorter like tabs in Vim,
   # handle paths starting with \\ and . correctly
   return ($loc -replace '\\(\.?)([^\\])[^\\]*(?=\\)','\$1$2')
}

function get-adminuser() {
   $id = [Security.Principal.WindowsIdentity]::GetCurrent()
   $p = New-Object Security.Principal.WindowsPrincipal($id)
   return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function prompt {
   # our theme
   $cdelim = [ConsoleColor]::DarkCyan
   $chost = [ConsoleColor]::Green
   $cpref = [ConsoleColor]::Cyan
   $cloc = [ConsoleColor]::DarkYellow

   if ( get-adminuser ) {
     $cpref = [ConsoleColor]::Yellow
   }
   write-host "$($env:COMPUTERNAME.ToLower())" -n -f $chost
   write-host ' | ' -n -f $cdelim
   write-host (shorten-path (pwd).Path) -n -f $cloc
   write-host '' -f $cdelim
   write-host "$([char]0x0A7)" -n -f $cpref
   return ' '
}

###############################################################################
# Other helper functions
###############################################################################
function to-hex([long] $dec) {
   return "0x" + $dec.ToString("X")
}
# open explorer in this directory
function exp([string] $loc = '.') {
   explorer "/e,"$loc""
}
# return all IP addresses
function get-ips() {
   $ent = [net.dns]::GetHostEntry([net.dns]::GetHostName())
   return $ent.AddressList | ?{ $_.ScopeId -ne 0 } | %{
      [string]$_
   }
}
# get the public IP address of my 
# home internet connection
function get-homeip() {
   $ent = [net.dns]::GetHostEntry("home.winterdom.com")
   return [string]$ent.AddressList[0]
}
# do a garbage collection
function run-gc() {
   [void]([System.GC]::Collect())
}

# start gitk without having to go through bash first
function gitk {
   wish "$TOOLS\git\bin\gitk"
}

# uuidgen.exe replacement
function uuidgen {
   [guid]::NewGuid().ToString('d')
}
# get our own process information
function get-myprocess {
   [diagnostics.process]::GetCurrentProcess()
}
# remove .svn directories
function remove-svn($path = '.') {
   ls -r -fo $path | ?{ 
      $_.PSIsContainer -and $_.Name -match '\.svn' 
   } | rm -r -fo
}
# get the syntax of a cmdlet, even if we have no help for it
function get-syntax([string] $cmdlet) {
   get-command $cmdlet -syntax
}
# calculate a hash from a string
function convert-tobinhex($array) {
   $str = new-object system.text.stringbuilder
   $array | %{
      [void]$str.Append($_.ToString('x2'));
   }
   return $str.ToString()
}
function convert-frombinhex([string]$binhex) {
   $arr = new-object byte[] ($binhex.Length/2)
   for ( $i=0; $i -lt $arr.Length; $i++ ) {
      $arr[$i] = [Convert]::ToByte($binhex.substring($i*2,2), 16)
   }
   return $arr
}
function get-hash($value, $hashalgo = 'MD5') {
   $tohash = $value
   if ( $value -is [string] ) {
      $tohash = [text.encoding]::UTF8.GetBytes($value)
   }
   $hash = [security.cryptography.hashalgorithm]::Create($hashalgo)
   return convert-tobinhex($hash.ComputeHash($tohash));
}
function escape-html($text) {
   $text = $text.Replace('&', '&amp;')
   $text = $text.Replace('"', '&quot;')
   $text = $text.Replace('<', '&lt;')
   $text.Replace('>', '&gt;')
}

# ugly, ugly, ugly
function to-binle([long]$val) {
   [Convert]::ToString($val, 2)
}

function byteToChar([byte]$b) {
   if ( $b -lt 32 -or $b  -gt 127 ) {
      '.'
   } else {
      [char]$b
   }
}
function format-bytes($bytes, $bytesPerLine = 8) {
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
function convertfrom-b64([string] $str) {
   [convert]::FromBase64String($str)
}
function normalize-array($array, [int]$offset, [int]$len=$array.Length-$offset) {
   $dest = new-object $array.GetType() $len
   [array]::Copy($array, $offset, $dest, 0, $len)
   $dest
}

# VHD helper functions for Win7
function add-vhd($vhdfile) {
   $path = resolve-path $vhdfile
   $script = "SELECT VDISK FILE=`"$path`"`r`nATTACH VDISK"
   $script | diskpart
}
function remove-vhd($vhdfile) {
   $path = resolve-path $vhdfile
   $script = "SELECT VDISK FILE=`"$path`"`r`nDETACH VDISK"
   $script | diskpart
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

# PE Helpers
# from http://stackoverflow.com/questions/1591557/how-to-tell-if-a-net-assembly-was-compiled-as-x86-x64-or-any-cpu/16181743#16181743
function Get-PEKind {
  Param(
    [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
    [System.IO.FileInfo]$assemblies
  )

  Process {
    foreach ($assembly in $assemblies) {
      $peKinds = new-object Reflection.PortableExecutableKinds
      $imageFileMachine = new-object Reflection.ImageFileMachine
      try {
        $a = [Reflection.Assembly]::LoadFile($assembly.Fullname)
          $a.ManifestModule.GetPEKind([ref]$peKinds, [ref]$imageFileMachine)
      }
      catch [System.BadImageFormatException] {
        $peKinds = [System.Reflection.PortableExecutableKinds]"NotAPortableExecutableImage"
      }

      $o = New-Object System.Object
      $o | Add-Member -type NoteProperty -name File -value $assembly
      $o | Add-Member -type NoteProperty -name PEKind -value $peKinds
      Write-Output $o
    }
  }
}

# load session helpers
."$SCRIPTS\sessions.ps1"

###############################################################################
# aliases
###############################################################################
set-alias fortune ${SCRIPTS}\fortune.ps1
set-alias ss select-string

###############################################################################
# Other environment configurations
###############################################################################
set-location $HOME
# OS default location needs to be set as well
[System.Environment]::CurrentDirectory = $HOME
