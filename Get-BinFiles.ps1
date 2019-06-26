<#
    .SYNOPSIS
    This script will downloads third party binaries required for KAPE modules and places them in the bin directory.
    .DESCRIPTION
    This script downloads EXE, PS1, and ZIP files identified in the BinaryUrl field of KAPE modules
    and extracts archives to the bin directory.
    
    To use, place this script in the KAPE\modules directory.
    .EXAMPLE
    C:\PS> Get-BinFiles.ps1 
    
    .NOTES
    Author: eSecRPM
    Date:   2019-03-21
    Update: 2019-06-26  Removed 7zip dependency and added logic for PS1 extensions
#>

# The following modules do not contain a BinaryUrl field that points directly to a downloadable
# script, exe, or zip file.  Binaries for these modules will need to be downloaded manually.
#
# ApplicationEvents.mkape
# ApplicationFullEventLogView.mkape
# Detailed-Network-Share-Access.mkape
# DumpIt.mkape
# Hashes.mkape
# Hindsight.mkape
# iTunesBackup.mkape
# Logon-Logoff-events.mkape
# Plaso.mkape
# PowerShell.mkape
# PowershellOperationalFullEventLogView.mkape
# PrintServiceOperationalFullEventLogView.mkape
# RDPCoreTS.mkape
# RDP-Usage-events.mkape
# Registry_System.mkape
# SecurityEvents.mkape
# SparkCore.mkape
# SystemEvents.mkape
# SystemFullEventLogView.mkape
# TaskScheduler.mkape
# TS-LSM.mkape
# TS-RCM.mkape
# usbdeviceforensics.mkape



$currentDirectory = (Resolve-Path ".")
$destinationDir = [string]$currentDirectory+"\bin\"

Get-ChildItem -Path $currentDirectory -Filter *.mkape | Get-Content | ForEach-Object {
	$items = $_.split()
	if ($items[0] -eq "BinaryUrl:"){
		$URL = [string]$items[1]
		$filename = Split-Path $URL -Leaf
        $start = $filename.lastIndexOf('.')+1
        $len = $filename.length
        $extension = $filename.Substring($start,$len-$start)
        
        Echo $URL
		
		if ($extension -eq "exe"){(New-Object System.Net.WebClient).DownloadFile($url,"$destinationDir$filename")}
		if ($extension -eq "ps1"){(New-Object System.Net.WebClient).DownloadFile($url,"$destinationDir$filename")}
		if ($extension -eq "zip"){
			(New-Object System.Net.WebClient).DownloadFile($url,"$destinationDir$filename")
            Expand-Archive -Path $destinationDir$filename -DestinationPath $destinationDir -Force
			Remove-Item -Path $destinationDir$filename
		}
	}
}

# densityscout, RECmd, SBECmd, sqlite3
Copy-Item -Path $destinationDir"win64\densityscout.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"RegistryExplorer\RECmd.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"ShellBagsExplorer\SBECmd.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"sqlite-tools-win32-x86-3270200\sqlite3.exe" -Destination $destinationDir -Force
