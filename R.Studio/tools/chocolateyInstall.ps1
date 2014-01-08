$version = '0.98'
$minor = '490'
Install-ChocolateyPackage 'R.Studio' 'exe' '/S' "http://download1.rstudio.org/RStudio-$version.$minor.exe"  -validExitCodes @(0)