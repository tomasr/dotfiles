param($inputFile, $outputFile)

$input = (Get-Content $inputFile) -join ""
$nows = $input -replace " ", ""


[byte[]]$result = new-object byte[] ($nows.Length/2)
for ( $i =0; $i -lt $nows.Length; $i += 2 ) {
    $result[$i/2] = [int]::Parse($nows[$i] + $nows[$i+1], 'HexNumber')
}

[IO.File]::WriteAllBytes($outputFile, $result)

