#import-module C:\Chocolatey\chocolateyInstall\helpers\chocolateyInstaller

$version = '1.6.1'
$name = "flyway-commandline-$version"
$url = "http://flyway.googlecode.com/files/$name-dist.zip"
$binRoot = Get-BinRoot
$flyway_home = Join-Path $binRoot $name
$flyway_cmd_source = Join-Path $flyway_home 'flyway.cmd'
$flyway_cmd_dest = Join-Path $env:CHOCOLATEYINSTALL 'bin\flyway.cmd'

Install-ChocolateyZipPackage 'flyway.commandline' $url $binRoot

"@echo off
$flyway_cmd_source %*" | Out-File $flyway_cmd_dest -encoding ASCII
    
"
flyway.commandline usage:
   flyway.cmd [options] command
   flyway.cmd -configFile=file.properties" | Write-Host	