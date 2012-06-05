#import-module C:\Chocolatey\chocolateyInstall\helpers\chocolateyInstaller

$global:python_home = $null
$global:python_version = $null

function _cmd($command) {
  $result = cmd.exe /c "$command 2>&1" #stderr hack  
  return $result
}

function Get-RegistryValue($key, $value) {
  $item = (Get-ItemProperty $key $value -ErrorAction SilentlyContinue)
  if ($item -ne $null) { return $item.$value } else { return $null }
}  

function Get-Python-Home() {
  $result = $env:PYTHONHOME
  
  if ($result -eq $null) {
    $result = $env:PYTHON_HOME
  }
  
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

function Read-Confirmation($message) {
  $caption = "Confirm";
  $yes = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes","help";
  $no = new-Object System.Management.Automation.Host.ChoiceDescription "&No","help";
  $choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no);
  $answer = $host.ui.PromptForChoice($caption,$message,$choices,0)

  switch ($answer){
    0 { return $true; break}
    1 { return $false; break}
  }
}

function Python-Exec($url, $name) {
  # _cmd "cd /d %TEMP% && curl -O $url && python $name"
  
  $filename = Join-Path $env:TEMP $name
  Get-ChocolateyWebFile 'easy.install' $filename $url
  
  if (has_file $filename) {
    Write-Host "Running python file: '$filename'"
    python $filename #todo: check if python not is in path
  }  
}

function Install-setuptools($version) {
  Write-Host 'Installing setuptools from http://pypi.python.org/pypi/setuptools ...'
  $pyvrs = $global:python_version.substring(0, 3) #2.7.3 >> 2.7
  
  if (is64bit) {
    Python-Exec 'http://peak.telecommunity.com/dist/ez_setup.py' 'ez_setup.py'
  }
  else {  
	$url = "http://pypi.python.org/packages/$version/s/setuptools/setuptools-$version.win32-py$pyvrs.exe"
	Install-ChocolateyPackage 'easy.install/setuptools' 'exe' '/S' $url	
  }
}

function Install-distribute() {	  
  Write-Host 'Installing distribute, Distribute is a fork of the Setuptools project. works with python versions >= 3.0'
  Write-Host 'distribute homepage: http://pypi.python.org/pypi/distribute'
  Python-Exec 'http://python-distribute.org/distribute_setup.py' 'distribute_setup.py'
}

function Install-easy-install() {
   $pyvrs = [int]$global:python_version.Replace('.', '').substring(0, 2) # 27

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
  return has_file (Join-Path $global:python_home 'Scripts\easy_install.exe')
}

function chocolatey-initialize() {
  $global:python_home = Get-Python-Home

  if ($global:python_home -eq $null) {
    if (Read-Confirmation 'Python not installed, Would you like to install Python now?' ) {
      Write-Host "Installing Python using chocolatey. Wait..."
      cinst python
	  $global:python_home = Get-Python-Home
    }	 
  } 

  if ($global:python_home -eq $null) {
    throw 'Python is not installed. easy_install installation aborted!'
  }
  
  Write-Host "Using python home at '$global:python_home'"

  if (($env:PYTHONHOME -eq $null) -and ($global:python_home -ne $null)) {
    Write-Host "Setting PYTHONHOME environment variable to '$global:python_home'"
    Write-Host "PS: PYTHONHOME variable is not required to Python works, but it is a good practice to have it."
    [Environment]::SetEnvironmentVariable('PYTHONHOME', $global:python_home, 'User')  
  }

  $global:python_version = Get-Python-Version

  if ($global:python_version -eq $null) {
    throw "Python Version could not be found. Executing 'python -V' at prompt works?"
  }
}  

function chocolatey-install() {
	try {
        chocolatey-initialize
	    Write-Host "Installing easy_install for Python($global:python_version)..."
	
		Install-easy-install
        $python_script_dir = Join-Path $global:python_home 'Scripts'
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

chocolatey-install # installs easy_install
