# KAPE-Binary-Downloads
Script to download binary tools for KAPE modules

Place this script in the KAPE\Modules directory.

This is a rudimentary script to enumerate each of the .mkape configuration files looking for a 'BinaryUrl' field with a .exe, .ps1, or
.zip extension. If found, the script will download the executable or zip to the KAPE\Modules\bin directory and extract any zip files.
The script also copies several executables from extracted subdirectories to the bin directory (densityscout, EvtxECmd, RBECmd, SBECmd,
sqlite3).

Know issues:

The script cannot download binaries for configuration files that do not provide a direct link to an executable or zip download
as specified in the 'BinaryUrl' field.

To Do:

[-] Add logic to check for existence of destination file to avoid unnecessary downloads

[-] Add logic to check for versioning of binaries to avoid downloading or overwriting an up-to-date file
