<#
    .SYNOPSIS
    Ths script will download binaries identified in each KAPE module and extract them to the bin directory. It is expected this script is run from the KAPE\modules directory. This script requires 7-zip binaries to be placed in a 7z folder within the root of the KAPE directory.
    .DESCRIPTION
    This script will attempt to download third party binaries required for KAPE modules and place them in the bin directory.
    .EXAMPLE
    C:\PS> Get-BinFiles.ps1 
    
    .NOTES
    Author: eSecRPM
    Date:   2019-03-21    
#>

# The following modules do not contain a BinaryUrl field that points directly to a downloadable
# zip file or exe.  Binaries for these modules will need to be downloaded manually.
#
# ApplicationEvents.mkape
# ApplicationFullEventLogView.mkape
# Detailed-Network-Share-Access.mkape
# exiftool.mkape
# Hindsight.mkape
# Logon-Logoff-events.mkape
# Plaso.mkape
# PowerShell.mkape
# PowershellOperationalFullEventLogView.mkape
# PrintServiceOperationalFullEventLogView.mkape
# RDPCoreTS.mkape
# RDP-Usage-events.mkape
# Registry_System.mkape
# SecurityEvents.mkape
# SystemEvents.mkape
# SystemFullEventLogView.mkape
# TaskScheduler.mkape
# TS-LSM.mkape
# TS-RCM.mkape



$currentDirectory = (Resolve-Path ".")
$destinationDir = [string]$currentDirectory+"\bin\"

if (!(test-path "..\7z\7za.exe")){
	Write-Host "`n..\7z\7za.exe needed! Exiting`n" -BackgroundColor Red
	return
} 
set-alias sz "..\7z\7za.exe"

Get-ChildItem -Path $currentDirectory -Filter *.mkape | Get-Content | ForEach-Object {
	$items = $_.split()
	if ($items[0] -eq "BinaryUrl:"){
		$URL = [string]$items[1]
		$filename = Split-Path $URL -Leaf
		$filename | ForEach-Object {
			$segments = $_.split('.')
			$extension = [string]$segments[1]
		}
		
		Echo $URL
		
		if ($extension -eq "exe"){(New-Object System.Net.WebClient).DownloadFile($url,"$destinationDir$filename")}
		if ($extension -eq "zip"){
			(New-Object System.Net.WebClient).DownloadFile($url,"$destinationDir$filename")
			sz x $destinationDir$filename -o"$destinationDir" -y > $null
			Remove-Item -Path $destinationDir$filename
		}
	}
}
		
# densityscout, RECmd, SBECmd, sqlite3
Copy-Item -Path $destinationDir"win64\densityscout.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"RegistryExplorer\RECmd.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"ShellBagsExplorer\SBECmd.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"sqlite-tools-win32-x86-3270200\sqlite3.exe" -Destination $destinationDir -Force
