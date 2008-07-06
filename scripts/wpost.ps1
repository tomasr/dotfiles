param([string] $url, [string] $file, [string] $contentType='text/xml')

$wr = [net.HttpWebRequest]([net.WebRequest]::Create($url))
$wr.Method = 'POST'
$wr.ContentType = $contentType
$is = $wr.GetRequestStream()

$content = [string](gc $file)
$isw = new-object io.StreamWriter $is
$isw.Write($content)
$isw.Flush()
$isw.Close()

$resp = $wr.GetResponse()

write $resp.Status

$sr = new-object io.StreamReader $resp.GetResponseStream()
write $sr.ReadToEnd()
