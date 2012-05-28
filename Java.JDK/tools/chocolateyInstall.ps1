### useful links ###
# https://github.com/adorepump/chocolatey-packages/tree/master/Java.JDK
# https://github.com/flexiondotorg/oab-java6/issues/22
# http://www.oracle.com/technetwork/java/javase/downloads/index.html
# 'http://download.oracle.com/otn-pub/java/jdk/7u4-b22/jdk-7u4-windows-i586.exe'
# 'http://download.oracle.com/otn-pub/java/jdk/7u4-b22/jdk-7u4-windows-x64.exe'

$jdk_version = '7u4' 
$java_version = '1.7.0' # cmd> java -version => "1.7.0_04"
$package_name = 'Java.JDK'

function _cmd($command) {
  Write-Host "executing cmd> $command"
  $result = cmd.exe /c "$command 2>&1" #stderr hack
  
  return $result
}

function is64bit() {
  return ([IntPtr]::Size -eq 8)
}

function has_file($filename) {
  return Test-Path $filename
}

function get-programfilesdir() {
  if (is64bit -eq $true) {
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
    w_cmd $cmd
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

    $filename = "jdk-7u4-windows-$osStr.exe"
    $url = "http://download.oracle.com/otn-pub/java/jdk/7u4-b22/$filename"
    $package_dir = Join-Path $env:TEMP "chocolatey\$package_name"
    $output_filename = Join-Path $package_dir $filename
    download-jdk-file $url $output_filename
    return $output_filename
}

function chocolatey-install() {
    try {
        Write-Host  "Downloading JDK using WGET, wait..."
        $jdk_file = download-jdk
        
        if (has_file $jdk_file) { 
          Write-Host "Installing JDK from file '$jdk_file'"
          Install-ChocolateyInstallPackage 'Java.jdk' 'exe' '/QN /NORESTART' $jdk_file          

          $program_files = get-programfilesdir
          $java_home = Join-Path $program_files "Java\jdk$java_version"   #jdk1.6.0_17
          $java_bin = Join-Path $java_home 'bin'
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
         
    } catch {
      Write-ChocolateyFailure 'Java.JDK' "$($_.Exception.Message)"
      throw 
    }
}

#installs Java.JDK
chocolatey-install    


