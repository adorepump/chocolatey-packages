$url='http://cran.rstudio.com/bin/windows/base/R-2.15.2-win.exe'
Install-ChocolateyPackage 'R.Project' 'exe' '/silent' "$url" -validExitCodes @(0)
