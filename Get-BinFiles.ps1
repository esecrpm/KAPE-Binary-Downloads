<#
	.SYNOPSIS
	This script downloads third party binaries required for KAPE modules and places them in the bin directory.

	.DESCRIPTION
	This script downloads EXE, PS1, and ZIP files identified in the BinaryUrl field of KAPE modules
	and extracts archives to the bin directory.
	
	To use, place this script in the KAPE\modules directory.
	
	The following modules do not contain a BinaryUrl field that points directly to a downloadable
	script, exe, or zip file.  Binaries for these modules will need to be downloaded manually.
	
	BrowsingHistory\Hindsight.mkape:6:BinaryUrl: https://github.com/obsidianforensics/hindsight/releases
	EventLogs\ApplicationFullEventLogView.mkape:6:BinaryUrl: https://www.nirsoft.net/utils/full_event_log_view.html
	EventLogs\Detailed-Network-Share-Access.mkape:6:BinaryUrl: https://www.microsoft.com/en-us/download/confirmation.aspx?id=24659
	EventLogs\Logon-Logoff-events.mkape:6:BinaryUrl: https://www.microsoft.com/en-us/download/confirmation.aspx?id=24659
	EventLogs\PowershellOperationalFullEventLogView.mkape:6:BinaryUrl: https://www.nirsoft.net/utils/full_event_log_view.html
	EventLogs\PrintServiceOperationalFullEventLogView.mkape:6:BinaryUrl: https://www.nirsoft.net/utils/full_event_log_view.html
	EventLogs\RDP-Usage-events.mkape:6:BinaryUrl: https://www.microsoft.com/en-us/download/confirmation.aspx?id=24659
	EventLogs\ScheduledTasksFullEventLogView.mkape:6:BinaryUrl: https://www.nirsoft.net/utils/full_event_log_view.html
	EventLogs\SecurityFullEventLogView.mkape:6:BinaryUrl: https://www.nirsoft.net/utils/full_event_log_view.html
	EventLogs\SMB-Server-Anonymous-Logon.mkape:6:BinaryUrl: https://www.microsoft.com/en-us/download/confirmation.aspx?id=24659
	EventLogs\SystemFullEventLogView.mkape:6:BinaryUrl: https://www.nirsoft.net/utils/full_event_log_view.html
	LiveResponse\DumpIt.mkape:6:BinaryUrl: https://my.comae.io
	LiveResponse\Hashes.mkape:6:BinaryUrl: https://github.com/gentilkiwi/mimikatz/releases
	Misc\Apache_Access_Log.mkape:6:BinaryUrl: https://www.microsoft.com/en-us/download/confirmation.aspx?id=24659
	Misc\iTunesBackup.mkape:6:BinaryUrl: https://github.com/jfarley248/iTunes_Backup_Analyzer/releases
	Misc\SEPM_Logs.mkape:6:BinaryUrl: https://github.com/Beercow/SEPparser/releases
	Misc\SparkCore.mkape:6:BinaryUrl: https://www.nextron-systems.com/spark-core/
	Misc\TaskScheduler.mkape:6:BinaryUrl: https://tzworks.net/download_links.php
	Registry\Registry_System.mkape:6:BinaryUrl: https://tzworks.net/download_links.php
	Registry\RegRipper-ALL.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Registry\RegRipper-ntuser.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Registry\RegRipper-sam.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Registry\RegRipper-security.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Registry\RegRipper-software.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Registry\RegRipper-system.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Timelining\Convert_unicode.mkape:6:BinaryUrl: https://github.com/mdegrazia/KAPE_Tools
	Timelining\EvtxECmd_to_TLN.mkape:6:BinaryUrl: https://github.com/mdegrazia/KAPE_Tools
	Timelining\RegRipper_AppCompatCache_TLN.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Timelining\RegRipper_NTUSER_muicache_TLN.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Timelining\RegRipper_NTUSER_userassit_TLN.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8
	Timelining\RegRipper_Services_TLN.mkape:6:BinaryUrl: https://github.com/keydet89/RegRipper2.8

	.EXAMPLE
	C:\PS> Get-BinFiles.ps1 
	
	.NOTES
	Author: eSecRPM
	Date:   2019-03-21
	
	ChangeLog
	2019-06-26  Removed 7zip dependency and added logic for PowerShell scripts
	2019-06-27	Moved list of modules without executable download links to description
				Select-String -Pattern BinaryUrl *.mkape | Where-Object { !( $_ | Select-String -Pattern "(.zip)|(.exe)|(.ps1)" -quiet) }
	2019-09-12	Updated to support sub-directory structure of KAPE modules as of 0.8.7.0
				Get-ChildItem -Recurse *.mkape | Select-String -Pattern BinaryUrl | Where-Object { !( $_ | Select-String -Pattern "(.zip)|(.exe)|(.ps1)" -quiet) }
#>


$currentDirectory = (Resolve-Path ".")
$destinationDir = [string]$currentDirectory+"\bin\"

Get-ChildItem -Path $currentDirectory -Recurse -Filter *.mkape | Get-Content | ForEach-Object {
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
Copy-Item -Path $destinationDir"EvtxExplorer\EvtxECmd.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"RegistryExplorer\RECmd.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"ShellBagsExplorer\SBECmd.exe" -Destination $destinationDir -Force
Copy-Item -Path $destinationDir"sqlite-tools-win32-x86-3270200\sqlite3.exe" -Destination $destinationDir -Force
