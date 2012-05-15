# http://www.microsoft.com/about/legal/en/us/Copyright/Default.aspx  #copyright
# $url = http://go.microsoft.com/fwlink/?linkid=149156  #major link
$url = 'http://silverlight.dlservice.microsoft.com/download/E/4/4/E44E1840-4BBE-4CFE-AA06-E739131D6B7E/10411.00/runtime/Silverlight.exe' #5.0
Install-ChocolateyPackage 'Silverlight' 'exe' '/q' "$url"  -validExitCodes @(0)
