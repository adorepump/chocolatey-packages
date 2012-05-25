
function _cmd($command) {
  Write-Host "executing cmd> $command"
  $result = cmd.exe /c "$command 2>&1" #stderr hack
  
  return $result
}

function Get-RegistryValue($key, $value) {
  (Get-ItemProperty $key $value).$value
}  

function Get-Python-Home() {
  $result = $env:PYTHONHOME
  
  if ($result -eq $null) {
    $filename = Get-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Python.exe" '(default)' 
  
    if ($filename -ne $null) {
      $file = Get-ChildItem $filename
      $result = $file.DirectoryName  
    }
  }  
  
  return $result
}

function Get-Python-Version() {
  $res = _cmd 'python -V' # Python 2.7.3
  
  if ($res -ne $null) {
	return $res.Replace('Python', '').Trim()
  }
  
  return $null  
}

function is64bit() {
  return ([IntPtr]::Size -eq 8)
}


#globals
$python_home = Get-Python-Home

if ($python_home -eq $null) {
  throw new Exception 'Cannot find PYTHON HOME, Check if Python is installed!'
}

$python_version = Get-Python-Version

if ($python_version -eq $null) {
  throw new Exception 'Python Version not defined'
}

function Install-setuptools($version) {
  Write-Host 'Installing setuptools from http://pypi.python.org/pypi/setuptools ...'
  $pyvrs = $python_version.substring(0, 3) #2.7.3 >> 2.7
  
  if (is64bit) {
	_cmd 'cd /d %TEMP% && curl -O http://peak.telecommunity.com/dist/ez_setup.py && python ez_setup.py'
  }
  else {  
	$url = "http://pypi.python.org/packages/$setuptools_version/s/setuptools/setuptools-$version.win32-py$pyvrs.exe"
	Install-ChocolateyPackage 'easy.install/setuptools' 'exe' '/S' $url	
  }
}

function Install-distribute() {	  
  Write-Host 'Installing distribute, Distribute is a fork of the Setuptools project. works with python versions >= 3.0'
  Write-Host 'distribute homepage: http://pypi.python.org/pypi/distribute'
  _cmd 'cd /d %TEMP% && curl -O http://python-distribute.org/distribute_setup.py && python distribute_setup.py'
}

function Install-easy-install() {
   $pyvrs = [int]$python_version.Replace('.', '').substring(0, 2) # 27

	if ($pyvrs -gt 27) {
      Install-distribute
	}
	else {
	  Install-setuptools '0.6c11'  
	}	  
}  

function has_file($filename) {
  return Test-Path $filename
} 

function Verify-installation() {
  return has_file (Join-Path $python_home 'Scripts\easy_install.exe')
}

function chocolatey-install() {
	try {
		Install-easy-install
        $python_script_dir = Join-Path $python_home 'Scripts'
        Install-ChocolateyPath $python_script_dir 'User'
        
        $status = Verify-installation
        
        if ($status) {
		  Write-ChocolateySuccess 'easy.install'
        }  
	
	} catch {
	  Write-ChocolateyFailure 'easy.install' "$($_.Exception.Message)"
	  throw 
	}
}

#Install-easy-install
chocolatey-install
