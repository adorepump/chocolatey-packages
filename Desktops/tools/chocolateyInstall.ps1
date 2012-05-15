#unzip
$dest = $env:USERPROFILE
Install-ChocolateyZipPackage 'Desktops' 'http://download.sysinternals.com/files/Desktops.zip' "$dest"

#shortcut
$target = Join-Path $dest 'Desktops.exe'
Install-ChocolateyDesktopLink $target 
