$url = 'http://wl.dlservice.microsoft.com/download/9/0/2/9027282A-A1AD-4676-B0A2-699309C37B2E/SkyDriveSetup.exe'
#Install-ChocolateyPackage 'SkyDrive' 'exe' '/silent' $url  -validExitCodes @(0)
Install-ChocolateyPackage 'SkyDrive' 'exe' '' $url  -validExitCodes @(0)

