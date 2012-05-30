#import-module C:\Chocolatey\chocolateyInstall\helpers\chocolateyInstaller

$extras = @{
  'name' = 'virtualenv';
  'description' = 'virtualenv is a tool to create isolated Python environments';
  'url' = 'http://www.virtualenv.org';
  'block' = {
     $workon_home = Join-Path $env:USERPROFILE '.virtualenvs'
     CreateFolder $workon_home
     [Environment]::SetEnvironmentVariable('PIP_RESPECT_VIRTUAL_ENV', 'true', "User")
     [Environment]::SetEnvironmentVariable('PIP_VIRTUALENV_BASE', $workon_home, "User")
     [Environment]::SetEnvironmentVariable('WORKON_HOME', $workon_home, "User")
  }	
}, @{
  'name' = 'fabric';
  'description' = 'Fabric is a library and command-line tool for streamlining the use of SSH for application deployment or systems administration tasks';
  'url' = 'http://fabfile.org'
}, @{
  'name' = 'ipython';
  'description' = 'IPython provides a rich toolkit to help you make the most out of using Python';
  'url' = 'http://ipython.org'  
}  
# @{'name'= 'buildout'; 'url' = 'http://www.buildout.org'; 'package' =  'zc.buildout' }

function CreateFolder ([string]$Path) {
  New-Item -Path $Path -type directory -Force
}

function get-Confirmation() {
  $names = $extras | ForEach-Object { $_.name} | Sort-Object  
  $str = [string]::join(', ', $names)  
  $res = Read-Host "Would you like to install common packages $str ? (y/n)"
  return ($res.ToLower() -eq 'y')
}

function install-extras() {
    $extras | ForEach-Object { 
      $name = $_.name
      $url = $_.url
      $description = $_.description      
      $package = if ($_.ContainsKey('package')) { $_.package } else { $name }
      $block = if ($_.ContainsKey('block')) { $_.block } else { $null }
      
      $cmd = "pip install $package"
      Write-Host "Installing package '$name'
      description: $description
      url: $url
      wait..."
      Write-Host $cmd 
      iex $cmd   
      
      if ($block -ne $null) {
        &$block
      }
      
      Write-Host ""      
    }  
}

function chocolatey-install() {
    try {
      easy_install pip
            
      $yesConfirmation = get-Confirmation
  
      if ($yesConfirmation) {
        install-extras
      }  
     
      Write-ChocolateySuccess 'pip'
    } catch {
      Write-ChocolateyFailure 'pip' "$($_.Exception.Message)"
      throw 
    }
}

#install-extras
chocolatey-install   