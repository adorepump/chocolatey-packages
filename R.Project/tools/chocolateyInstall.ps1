$url='http://cran.rstudio.com/bin/windows/base/R-3.0.3-win.exe'
Install-ChocolateyPackage 'R.Project' 'exe' '/silent' "$url" -validExitCodes @(0)
