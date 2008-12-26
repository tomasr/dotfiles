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
   if ( (test-path $sdkdir) ) {
      $env:JDK_HOME = $sdkdir
      append-path "$sdkdir\bin"
      #append-classpath "$sdkdir\lib"
   }

   $jredir = (resolve-path "$baseloc\jre*")
   if ( (test-path $jredir) ) {
      $env:JAVA_HOME = $jredir
      append-path "$kredir\bin"
      #append-classpath "$jdkdir\lib"
   }
   append-classpath "."
}


