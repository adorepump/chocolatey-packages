# SETX NODE_PATH %PROGRAMFILES%\nodejs\node_modules
# %APPDATA%\npm\node_modules

function is64bit() {
  return ([IntPtr]::Size -eq 8)
}

function get-programfilesdir() {
  if (is64bit -eq $true) {
    (Get-Item "Env:ProgramFiles(x86)").Value
  }
  else {
    (Get-Item "Env:ProgramFiles").Value
  }
}

$program_files = get-programfilesdir

cd "$program_files\nodejs"
invoke-expression "npm install -g coffee-script"
