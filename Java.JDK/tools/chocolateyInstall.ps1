### useful links ###
# https://github.com/adorepump/chocolatey-packages/tree/master/Java.JDK
# https://github.com/flexiondotorg/oab-java6/issues/22
# http://www.oracle.com/technetwork/java/javase/downloads/index.html
# 'http://download.oracle.com/otn-pub/java/jdk/7u4-b22/jdk-7u4-windows-i586.exe'
# 'http://download.oracle.com/otn-pub/java/jdk/7u4-b22/jdk-7u4-windows-x64.exe'

$jdk_version = '7u45' 
$java_version = '1.7.0' # cmd> java -version => "1.7.0_04"
$package_name = 'Java.JDK'

function _cmd($command) {
  Write-Host "executing cmd> $command"
  $result = cmd.exe /c "$command 2>&1" #stderr hack
  
  return $result
}

function use64bit() {
  $is64bitOS = (Get-WmiObject -Class Win32_ComputerSystem).SystemType -match ‘(x64)’
  return $is64bitOS -and ($params.x64 -ne $false)
}

function has_file($filename) {
  return Test-Path $filename
}

function get-programfilesdir() {
  if (use64bit -eq $false) {
    (Get-Item "Env:ProgramFiles(x86)").Value
  }
  else {
    (Get-Item "Env:ProgramFiles").Value
  }
}

function set-env-var([string]$name, [string]$value, [string]$type = 'User') {
   if ($type -eq 'Machine') {
    $cmd  = "[Environment]::SetEnvironmentVariable('$name', '$value', 'Machine')"	
	Start-ChocolateyProcessAsAdmin $cmd
  }
  else {
    [Environment]::SetEnvironmentVariable($name, $value, 'User')
  }
}

function download-from-oracle($url, $output_filename, $part) {
  if (-not (has_file($output_fileName))) {
    $cookies="oraclelicense$part-oth-JPR=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com"
    $cmd = "wget --no-check-certificate --header=""Cookie: $cookies"" -x -c ""$url"" -O ""$output_filename"""  # -nc
    _cmd $cmd
  }  
}

function download-jdk-file($url, $output_filename) {
  download-from-oracle $url $output_filename "jdk-$jdk_version"
}

function download-jdk() {
    $arch = get-arch

    $filename = "jdk-7u45-windows-$arch.exe"
    $url = "http://download.oracle.com/otn-pub/java/jdk/7u45-b18/$filename"
    $package_dir = Join-Path $env:TEMP "chocolatey\$package_name"
    $output_filename = Join-Path $package_dir $filename
    download-jdk-file $url $output_filename
    return $output_filename
}

function get-installationDir-override(){
	if($params.path -ne $null){
		return "INSTALLDIR=$($params.path)"
	} else {
		return $null
	}
}

function get-java-home() {
	if($params.path -ne $null) {
		return $params.path
	} else {
		$program_files = get-programfilesdir
		return Join-Path $program_files "Java\jdk$java_version" #jdk1.6.0_17
	}
}

function get-java-bin() {
	$java_home = get-java-home
	return	Join-Path $java_home 'bin'
}

function get-arch() {
	if(use64bit) {
		return "x64"
	} else {
		return "i586"
	}
}

function chocolatey-install() {
	Write-Host  "Downloading JDK using WGET, wait..."
	$jdk_file = download-jdk
	
	if (has_file $jdk_file) {
	  $arch = get-arch
	  $java_home = get-java-home
	  Write-Host "Installing JDK ($arch) from file '$jdk_file' to $java_home"
	  
	  $installDirOverride = get-installationDir-override
	  Install-ChocolateyInstallPackage 'Java.jdk' 'exe' "/s $installDirOverride" $jdk_file          

	  $java_bin = get-java-bin
	  Install-ChocolateyPath $java_bin 'Machine'                 
			 
	  if ([Environment]::GetEnvironmentVariable('CLASSPATH','Machine') -eq $null) {
		set-env-var 'CLASSPATH' '.;' "Machine"    
	  }
	
	  set-env-var 'JAVA_HOME' $java_home 'Machine'          
	  
	  Write-ChocolateySuccess 'Java.JDK'
	} 
	else {
	  Write-ChocolateyFailure 'Java.JDK' "File '$jdk_file' not found"
	}
}

#installs Java.JDK
try {
	$params = (ConvertFrom-StringData ($env:chocolateyPackageParameters -replace ";", "`n")) # -params '"x64=false;path=c:\\java\\jdk"'
	chocolatey-install  
} catch {
  Write-ChocolateyFailure 'Java.JDK' "$($_.Exception.Message)"
  throw 
}  


