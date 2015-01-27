# http://www.microsoft.com/about/legal/en/us/Copyright/Default.aspx  #copyright
$url = 'http://go.microsoft.com/fwlink/?LinkID=229320'
$url64bit = 'http://go.microsoft.com/fwlink/?LinkID=229324'
Install-ChocolateyPackage 'Silverlight' 'exe' '/q' "$url" "$url64bit"  -validExitCodes @(0)
