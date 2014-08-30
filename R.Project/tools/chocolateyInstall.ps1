$url='http://cran.at.r-project.org/bin/windows/base/R-2.15.3-win.exe'
Install-ChocolateyPackage 'R.Project' 'exe' '/silent' "$url" -validExitCodes @(0)
