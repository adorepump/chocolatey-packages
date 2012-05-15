#download and unzip package
$version = '1.5.1'
$name = "processing-$version"
$processor = Get-WmiObject Win32_Processor
$is64bit = $processor.AddressWidth -eq 64
$program_files = ''
if ($is64bit) {
  $program_files = "$env:ProgramFiles(x86)"
  $program_files = $program_files.Replace('Program Files(x86)', 'Program Files (x86)')
}  
else {
  $program_files = "$env:ProgramFiles"
}

$dest = Join-Path $program_files 'Processing'
Install-ChocolateyZipPackage 'Processing' "http://processing.googlecode.com/files/$name-windows.zip" "$dest"

#shortcut
$target = Join-Path (Join-Path $dest $name) 'Processing.exe'
Install-ChocolateyDesktopLink $target
