###############################################################################
# Configures a Java build environment based on whatever 
# java SDK is found
###############################################################################


function script:append-path { 
   if ( -not $env:PATH.contains($args) ) {
      $env:PATH += ';' + $args
   }
} 
function script:append-classpath { 
   if ( [String]::IsNullOrEmpty($env:CLASSPATH) ) {
      $env:CLASSPATH = $args
   } else {
      $env:CLASSPATH += ';' + $args
   }
} 

$baseloc = "$env:ProgramFiles\Java\"
if ( (test-path $baseloc) ) {
   $sdkdir = (resolve-path "$baseloc\jdk*")
   if ( $sdkdir -ne $null -and (test-path $sdkdir) ) {
      $env:JDK_HOME = $sdkdir
      append-path "$sdkdir\bin"
   }

   $jredir = (resolve-path "$baseloc\jre*")
   if ( $jredir -ne $null -and (test-path $jredir) ) {
      $env:JAVA_HOME = $jredir
      append-path "$kredir\bin"
   }
   append-classpath "."
}


