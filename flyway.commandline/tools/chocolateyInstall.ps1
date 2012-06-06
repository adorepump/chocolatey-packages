#import-module C:\Chocolatey\chocolateyInstall\helpers\chocolateyInstaller

function get-binRoot() {
  if($env:chocolatey_bin_root -ne $null) {
    $binRoot = $env:chocolatey_bin_root
  }
  else {
    $binRoot = 'bin'
  }
  
  return Join-Path $env:systemdrive $binRoot
}

$version = '1.6.1'
$name = "flyway-commandline-$version"
$url = "http://flyway.googlecode.com/files/$name-dist.zip"
$binRoot = get-binRoot
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