#cmd> mvn -version

#create folder if not exists
function CreateFolder ([string]$Path) {
  New-Item -Path $Path -type directory -Force
}

$binRoot = join-path $env:systemdrive 'bin'

### Using an environment variable to define the bin root until we implement YAML configuration ###
if($env:chocolatey_bin_root -ne $null){
  $binRoot = join-path $env:systemdrive $env:chocolatey_bin_root
}

CreateFolder($binRoot)

$version = '3.0.5'
$name = "apache-maven-$version"
$m2_home = Join-Path $binRoot $name
$m2_bin = Join-Path $m2_home 'bin'
$m2_repo = Join-Path $env:USERPROFILE '.m2'

#$url = "http://apache.mirror.pop-sc.rnp.br/apache/maven/binaries/$name-bin.zip"
#$url = "http://ftp.unicamp.br/pub/apache/maven/binaries/$name-bin.zip"
$url = "http://www.bizdirusa.com/mirrors/apache/maven/maven-3/$version/binaries/$name-bin.zip"


[Environment]::SetEnvironmentVariable('M2_HOME', $m2_home, "User")
[Environment]::SetEnvironmentVariable('MAVEN_OPTS', '-Xms256m', "User")
[Environment]::SetEnvironmentVariable('M2', $m2_bin, "User")
[Environment]::SetEnvironmentVariable('M2_REPO', $m2_repo, "User")

Install-ChocolateyZipPackage 'Maven' $url $binRoot #download the maven .zip and unzip in $binRoot folder

CreateFolder($m2_repo)

Install-ChocolateyPath $m2_bin 'User' #add to path

