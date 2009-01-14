#
# Simple script to save and restore powershell sessions
# Our concept of session is simple and only considers:
#   - history
#   - The current directory
#

function script:get-sessionfile([string] $sessionName) {
   return "$([io.path]::GetTempPath())$sessionName";
}

function export-session {
   param ([string] $sessionName = "session-$(get-date -f yyyyMMddhh)")
   $file = (get-sessionfile $sessionName)
   (pwd).Path > "$file-pwd.ps1session"
   get-history | export-csv "$file-hist.ps1session"
   "Session $sessionName saved"
}

function import-session([string] $sessionName) {
   $file = (get-sessionfile $sessionName)
   if ( -not [io.file]::Exists("$file-pwd.ps1session") ) {
      write-error "Session file doesn't exist"
   } else {
      cd (gc "$file-pwd.ps1session")
      import-csv "$file-hist.ps1session" | add-history
   }
}
