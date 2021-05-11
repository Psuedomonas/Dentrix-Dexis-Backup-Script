<#
Dentrix (and vicariously Dexis) Autobackup Version 1.1
by Nicholas Zehm
This version abandons the windows form interface an simply uses a console
#>

$global:dentrix = "C:\Dentrix\Common" #Adjust to Dentrix save directory

#debug mode - Turns on a log, useful for checking for backup errors, but is set to append so it will grow overlarge eventually.
$debug = $true

if ($debug) {
	$logDirectory = "C:\NicksLog\AutoBackupLog.txt"
}

## Boolean globals to direct backup script
$global:shutdownComp = $false
$global:startTheBackup = $false

#Add GUI stuff
Add-Type -assembly System.Windows.Forms
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog

if ($debug -eq 1) {
	Start-Transcript -path $logDirectory -appen #I can set this to later in the code... at a later time
}

Write-Host "Step 1: Choose backup directory"

Write-Host "Choose the location to put backup"
Write-Host ""
Write-Host "(Note, a browser menu has appeared. It may be hidden so check your task bar if you don't see it...)"

[void] $FolderBrowserDialog.ShowDialog()

$time = Get-Date -Format "MM.dd.yyyy"
$testDir = $FolderBrowserDialog.SelectedPath + '\' + $time
$alreadyThere = Test-Path $testDir -PathType Any
       
if (!$alreadyThere) {
	$global:x = $FolderBrowserDialog.SelectedPath
    $global:startTheBackup = $true
}
else {
    Write-Host ""
    $UserInput = Read-Host "FILE ALREADY EXISTS! Over-write file? (y/n)?"
    if ($UserInput -eq 'y') {
        $global:x = $FolderBrowserDialog.SelectedPath
        $global:startTheBackup = $true
    }
}

$backupDir = $global:x + '\' + $time

if (!$global:startTheBackup) {
    Write-Host "An error occured, try running the script again"
    Return
}
$backupDir = $global:x + '/' + $time
New-Item -Path $global:x -Name $time -ItemType "directory" -Force
Write-Host $backupDir "created!"
Write-Host ""
Write-Host "Step 2: Backup Dexis"
Write-Host ""
Write-Host "A. Launch Dexis"
Write-Host "B. Click lock button"
Write-Host "C. Select 'Settings' Tab"

$condensed = "D. Set the directory to " + $global:x + "\" + $time
Write-Host $condensed

Write-Host "E. Select 'Backup tab"
Write-Host "F. Press button to start backup"
Write-Host ""

$UserInput = Read-Host "Once the Dexis backup has has started, type 'proceed' and hit enter"
if ($UserInput -ne 'proceed') {
    Do {
        $UserInput = Read-Host "Once the Dexis backup has has started, type 'proceed' and hit enter"
    }
    While ($UserInput -ne "proceed")
}

Write-Host "While the backup is occuring, we can begin the Dentrix backup"

Write-Host ""
Write-Host "Step 3: Initialize backup of Dentrix"
Write-Host ""
Write-Host "A. Run _ServerAdmin"
Write-Host "B. Select Export Backup Tab"
Write-Host "C: Press Export Backup Button"
Write-Host ""

$UserInput = Read-Host "Once the Dentrix _ServerAdmin backup has completed, type 'proceed' and hit enter"
if ($UserInput -ne 'proceed') {
    Do {
        $UserInput = Read-Host "Once the Dentrix _ServerAdmin backup has completed, type 'proceed' and hit enter"
    }
    While ($UserInput -ne "proceed")
}

$UserInput = Read-Host "Now the final backup step (4). Do you want the computer to shutdown after it completes (y/n or c to cancel)?"
if ($UserInput -eq 'y') {
    $global:shutdownComp = $true
}
elseif ($UserInput -eq 'c') {
    Return
}

if ($global:startTheBackup) {

		
	## Perform Dentrix Backup ##
	Write-Host "Performing the Dentrix Backup..."
	Copy-Item $global:dentrix -Destination $backupDir -Recurse -Force
	Write-Host "Dentrix Backup Complete!"
	
	## Get time for logging
	Get-Date -UFormat "%c"

	if ($global:shutdownComp) { #do we shut the computer down?
		Write-Host "Shutting down computer..."

		Stop-Computer # when backup is complete, shut down computer
	}
}
Write-Host "Script Completed!!!"