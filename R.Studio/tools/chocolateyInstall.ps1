$version = '0.95'
$minor = '265'
Install-ChocolateyPackage 'R.Studio' 'exe' '/S' "http://download1.rstudio.org/RStudio-$version.$minor.exe"  -validExitCodes @(0)