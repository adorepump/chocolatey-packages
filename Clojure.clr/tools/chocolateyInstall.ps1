# http://clojure.org
#$lib2_url = 'https://github.com/downloads/clojure/clojure-clr/lib2.zip'
#Install-ChocolateyZipPackage 'Clojure.NET' $lib2_url "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"  
#(For some versions of Windows) Clear the ‘downloaded from the internet flag’ by right-clicking the zip file in the File Explorer and selecting the Unblock box.  

$version = '1.3.0'
$dist_type = 'Debug' # or Release
$clr_version = '3.5'
$net_version = gci 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' | sort pschildname -des | select -fi 1 -exp pschildname

if ($net_version.IndexOf('4') -ge 0) {
  $clr_version = '4.0'
}

$name = "clojure-clr-$version-$dist_type-$clr_version"
$url = "https://github.com/downloads/clojure/clojure-clr/$name.zip"
$dest = Join-Path "$env:USERPROFILE" $name
Install-ChocolateyZipPackage 'Clojure.NET' $url $dest

#shorcut
$target = Join-Path $dest 'Clojure.Main.exe'
Install-ChocolateyDesktopLink $target  
