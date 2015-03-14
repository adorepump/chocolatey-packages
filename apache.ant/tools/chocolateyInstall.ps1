# ant - v

# Unable to locate tools.jar. Expected to find it in c:\program files (x86)\java\jre6\lib\tools.jar
# JAVA_HOME > C:\Program Files (x86)\Java\jdk1.6.0_17

function CreateFolder ([string]$Path) {
  New-Item -Path $Path -type directory -Force
}

$binRoot = Get-BinRoot

CreateFolder($binRoot)

$version = '1.8.4'
$name = "apache-ant-$version" 
$url = "http://archive.apache.org/dist/ant/binaries/$name-bin.zip"
$ant_home = Join-Path $binRoot $name
$ant_bin = Join-Path  $ant_home 'bin'

Install-ChocolateyZipPackage 'apache.ant' $url $binRoot

[Environment]::SetEnvironmentVariable('ANT_HOME', $ant_home, "User")
[Environment]::SetEnvironmentVariable('ANT_OPTS', '-Xmx256M', "User")

Install-ChocolateyPath $ant_bin 'User' #add to path
