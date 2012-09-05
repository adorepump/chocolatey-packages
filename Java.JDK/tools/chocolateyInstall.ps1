### useful links ###
# https://github.com/adorepump/chocolatey-packages/tree/master/Java.JDK
# https://github.com/flexiondotorg/oab-java6/issues/22
# http://www.oracle.com/technetwork/java/javase/downloads/index.html
# 'http://download.oracle.com/otn-pub/java/jdk/7u4-b22/jdk-7u4-windows-i586.exe'
# 'http://download.oracle.com/otn-pub/java/jdk/7u4-b22/jdk-7u4-windows-x64.exe'

$jdk_version = '7u7' 
$java_version = '1.7.0_07' # cmd> java -version => "1.7.0_04"
$package_name = 'Java.JDK'

function wcmd($command) {
  Write-Host "executing cmd> $command"
  $result = cmd.exe /c "$command 2>&1" #stderr hack
  
  return $result
}

function is64bit() {
  return ([IntPtr]::Size -eq 8)
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
  if (-not (test-path $output_fileName)) {
    $cookies="oraclelicense$part-oth-JPR=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com"
    $cmd = "wget --no-check-certificate --header=""Cookie: $cookies"" -x -c ""$url"" -O ""$output_filename"""  # -nc
    wcmd $cmd
  }  
}

function download-jdk-file($url, $output_filename) {
  download-from-oracle $url $output_filename "jdk-$jdk_version"
}

function download-jdk() {
    if (is64bit) {
      $osStr = 'x64'
    }
    else {
      $osStr = 'i586'
    }

    $filename = "jdk-7u7-windows-$osStr.exe"
    $url = "http://download.oracle.com/otn-pub/java/jdk/7u7-b10/$filename"
    $package_dir = Join-Path $env:TEMP "chocolatey\$package_name"
    if(-not(test-path $package_dir)){mkdir $package_dir}
    $script:InstallPath = Join-Path $package_dir $filename
    download-jdk-file $url $script:InstallPath
}

function chocolatey-install() {
    try {
        Write-Host  "Downloading JDK using WGET, wait..."
        download-jdk
        if (test-path $script:InstallPath) { 
          Write-Host "Installing JDK from file '$script:InstallPath'"
          Install-ChocolateyInstallPackage 'Java.jdk' 'exe' '/QN /NORESTART' $script:InstallPath          

          $java_home = Join-Path $Env:ProgramFiles "Java\jdk$java_version"   #jdk1.7.0_07
          $java_bin = Join-Path $java_home 'bin'
          Install-ChocolateyPath $java_bin 'Machine'                 
                 
          if ([Environment]::GetEnvironmentVariable('CLASSPATH','Machine') -eq $null) {
            set-env-var 'CLASSPATH' '.;' "Machine"    
          }
            
          set-env-var 'JAVA_HOME' $java_home 'Machine'          
          
          Write-ChocolateySuccess 'Java.JDK'
        } 
        else {
          Write-ChocolateyFailure 'Java.JDK' "File '$script:InstallPath' not found"
        }
         
    } catch {
      Write-ChocolateyFailure 'Java.JDK' "$($_.Exception.Message)"
      throw 
    }
}

#installs Java.JDK
chocolatey-install    


