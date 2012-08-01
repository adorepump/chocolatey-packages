#import-module C:\Chocolatey\chocolateyInstall\helpers\chocolateyInstaller

$version = '1.0.6'
Install-ChocolateyPackage 'visualsubst' 'exe' '/S' "http://www.ntwind.com/download/VSubst_$version.exe"  -validExitCodes @(0)
