$version = '4.5.1'
$url = "http://ufpr.dl.sourceforge.net/project/ireport/iReport/iReport-$version/iReport-$version-windows-installer.exe"
Install-ChocolateyPackage 'iReport' 'exe' '/S' $url -validExitCodes @(0)
