Install-ChocolateyPackage 'Vagrant.install' 'msi' '/quiet' 'http://files.vagrantup.com/packages/eb590aa3d936ac71cbf9c64cf207f148ddfc000a/vagrant_1.0.3.msi'

$binDir = join-path $env:chocolateyinstall 'bin'
$batchVagrant = Join-Path $binDir 'vagrant.bat'
$executable = 'C:\vagrant\vagrant\bin\vagrant.bat'
"@echo off
$executable %*" | Out-File $batchVagrant -encoding ASCII
