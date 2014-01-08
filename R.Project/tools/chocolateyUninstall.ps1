$unpath="${Env:ProgramFiles}\R\R-3.0.2\unins000.exe"
Uninstall-ChocolateyPackage 'R.Project' 'exe' '/silent' "$unpath" -validExitCodes @(0)
