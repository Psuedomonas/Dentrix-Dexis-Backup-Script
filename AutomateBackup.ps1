<#
Dentrix (and vicariously Dexis) Autobackup Version 2
by Nicholas Zehm
This version abandons the windows form interface and simply uses a console
#>

$global:dentrix = "C:\Dentrix\Common" #Adjust to Dentrix save directory, a more concise approach/directory may exist but this method has worked for recovery.


#debug mode - Turns on a log, useful for checking for backup errors, but is set to append so it will grow overlarge eventually.
$debug = $true


if ($debug) {
	$logDirectory = "C:\NicksLog\AutoBackupLog.txt"
}


# Boolean globals to direct backup script
$global:shutdownComp = $false
$global:startTheBackup = $false


#Add GUI stuff
Add-Type -assembly System.Windows.Forms
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog


if ($debug) { #If true, start logging
	Start-Transcript -path $logDirectory -appen
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



if (!$global:startTheBackup) {
    Write-Host "An error occured, try running the script again"
    Return
}


#Note new directory for interface & documentation
$backupDir = $global:x + '\' + $time

#Make the folder named from $time, in directory from global:x
New-Item -Path $global:x -Name $time -ItemType "directory" -Force

Write-Host $backupDir "created!"
Write-Host ""
Write-Host "Step 2: Backup Dexis"
Write-Host ""
Write-Host "A. Launch Dexis"
Write-Host "B. Click lock button"
Write-Host "C. Select 'Settings' Tab"

#Easier to just make a string and print the string. Could just use $backupDir...
$condensed = "D. Set the directory to " + $global:x + "\" + $time
Write-Host $condensed

Write-Host "E. Select 'Backup tab"
Write-Host "F. Press button to start backup"
Write-Host ""

#Ensure that dexis update has been started. Since these backups can occur simultaneously, we only need to make sure the user has begun the backup
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

#We need the _ServerAdmin.exe backup to be complete before we begin the final backup step
$UserInput = Read-Host "Once the Dentrix _ServerAdmin backup has completed, type 'proceed' and hit enter"
if ($UserInput -ne 'proceed') {
    Do {
        $UserInput = Read-Host "Once the Dentrix _ServerAdmin backup has completed, type 'proceed' and hit enter"
    }
    While ($UserInput -ne "proceed")
}

#User decides if computer should shutdown after backup, also given a chance to cancel the backup
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
