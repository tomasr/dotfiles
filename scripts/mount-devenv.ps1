# mount my dev environment as a shared drive
param([switch]$asVHD=$false)

if ( $asVHD ) {
   # todo: implement this, ugh.
} else {
   subst n: \\inferno\e$
}
