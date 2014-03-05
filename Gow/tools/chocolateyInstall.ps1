$version='0.8.0'
Install-ChocolateyPackage 'Gow' 'exe' '/S' "https://github.com/bmatzelle/gow/releases/download/v$version/Gow-$version.exe"  -validExitCodes @(0)