$unpath="${Env:ProgramFiles}\R\R-2.15.1\unins000.exe"
Uninstall-ChocolateyPackage 'R.Project' 'exe' '/silent' "$unpath" -validExitCodes @(0)
