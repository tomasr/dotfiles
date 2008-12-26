###############################################################################
# powershell initialization script
# call from profile.ps1, like this:
#     . "$env:HOME\_profile.ps1"
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
$TOOLS = 'e:\tools'
$SCRIPTS = "$HOME\scripts"
$env:EDITOR = 'gvim.exe'

#
# set path to include my usual directories
# and configure dev environment
#
function script:append-path { 
   if ( -not $env:PATH.contains($args) ) {
      $env:PATH += ';' + $args
   }
}

& "$SCRIPTS\devenv.ps1"
& "$SCRIPTS\javaenv.ps1"

append-path $TOOLS
append-path (resolve-path "$TOOLS\svn-*\bin")
append-path (resolve-path "$TOOLS\nant-*")
append-path "$TOOLS\vim"
append-path "$TOOLS\gnu"
append-path "$TOOLS\git\bin"


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

function prompt {
   # our theme
   $cdelim = [ConsoleColor]::DarkCyan
   $chost = [ConsoleColor]::Green
   $cpref = [ConsoleColor]::Cyan
   $cloc = [ConsoleColor]::Magenta

   write-host "$([char]0x0A7) " -n -f $cpref
   write-host ([net.dns]::GetHostName()) -n -f $chost
   write-host ' {' -n -f $cdelim
   write-host (shorten-path (pwd).Path) -n -f $cloc
   write-host '}' -n -f $cdelim
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
# launch VS dev webserver, from Harry Pierson
# http://devhawk.net/2008/03/20/WebDevWebServer+PowerShell+Function.aspx
function webdev($path,$port=8080,$vpath='/') {
    $spath = "$env:ProgramFiles\Common*\microsoft*\DevServer\9.0\WebDev.WebServer.EXE"

    $spath = resolve-path $spath
    $rpath = resolve-path $path
    &$spath "/path:$rpath" "/port:$port" "/vpath:$vpath"
    "Started WebDev Server for '$path' directory on port $port"
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
###############################################################################
# aliases
###############################################################################
set-alias fortune ${SCRIPTS}\fortune.ps1
set-alias ss select-string

###############################################################################
# Other environment configurations
###############################################################################
set-location $HOME
