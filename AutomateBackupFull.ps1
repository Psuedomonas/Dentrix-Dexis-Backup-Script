<#
AutomateBackupFull.ps1
Dentrix & Dexis Backup
Version 2.5 - 9/04/2022
by Nicholas Zehm
For use with Dentrix 5-7 and Dexis 10

These scripts use so called 'dumb' backups, as these are simple and safest for our situation.
This particular script copies the full directories of both Dexis and Dentrix as this seems to correlate to best recovery.
Version 2.4 will remain the version for using Dentrix and Dexis backup features.
#>


<# 
Configuration Logging
#>

#debug mode - Turns on a log, useful for checking for backup errors
# However append will grow overlarge eventually.
$debug = $false
$append = $false

#The log directory
if ($debug) {
	$logDirectory = "C:\NicksLog\backup-powershell_v2.5_Log.txt"
}

# Log Code - I may move this elsewhere soon
if ($debug -and $append) 
{ #If true, start logging
	Start-Transcript -path $logDirectory -appen
    Write-Host "Log in append mode"
}
elseif ($debug -and -not $append) { #start logging, overwrite log
    Start-Transcript -path $logDirectory
    Write-Host "Log in overwrite mode"
}


<#
Configure backup directories
#>
$global:Dentrix = "C:\Dentrix"
$global:Dexis = "C:\Dexis"

<#
Background process list
#>
$global:processList = 'Geany', 'Okular'

#processes off status variable
$global:processesoff = $false


<#
Functions
#>
# Folder Browser Dialog - I do this differently in V2.4
Function Get-Backup-Destination($initialDirectory="") {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Chose backup destination"
    $foldername.SelectedPath = $initialDirectory

    if ($foldername.ShowDialog() -eq "OK")
    {
        $folder = $foldername.SelectedPath
    }
    else {
        Write-Host "No folder selected. Ending script"
        exit
    }

    return $folder
}

#Simply kill processes in list. Nothing nice about it
Function Close-Background-Processes() {
    Foreach ($i in $global:processList)
    {
            Get-Process -Name $i -ErrorAction SilentlyContinue | Stop-Process -Force
    }
    $global:processesoff = $true
}

<#
#This is not how its done!
Function Restart-Background-Process() 
{
    if ($global:processesoff) 
    {
        Foreach ($i in $global:processList)
        {
            Start-Process -name $i
        }

    }
}
#>


<#
The Actual Script
#>
Write-Host "Warning: This backup will require the shutdown of Dentrix and Dexis backround processes."
Write-Host "If you need to enter new data into the system, cancel this backup or wait until backup is complete."
Write-Host "If you choose to keep the system on after backup, you may need to reboot the computer or restart the background processes"
Write-Host "" 

$dentrix_size = (Get-ChildItem -Path $global:Dentrix -Recurse -Force | Measure-Object -Sum Length).Sum
Write-Host "Dentrix requires:" $dentrix_size

$dexis_size = (Get-ChildItem -Path $global:Dexis -Recurse -Force | Measure-Object -Sum Length).Sum
Write-Host "Dexis requires:" $dexis_size

# Make sure there is enough space, can be ~160gb, but may vary for many reasons.
$requiredspace = $dentrix_size + $dexis_size

Write-Host "REQUIRED FOR BACKUP"
Write-Host $requiredspace
Write-Host ''
Write-Host "Dexis & Dentrix Backup"
Write-Host "Choose the location to put backup"
Write-Host "(Note, a browser menu has appeared. It may be hidden so check your task bar if you don't see it...)"

#Call folder dialog box to get backup destination
$destDir = Get-Backup-Destination

#Setup the destination
$time = Get-Date -Format "MM.dd.yyyy"
$testDir = $destDir + '\' + $time

#Check that destination is clear
$alreadyThere = Test-Path $testDir -PathType Any

#Check if directory already exists
if (!$alreadyThere) {
	$global:x = $testDir
    $global:startTheBackup = $true
}
else {
    Write-Host ""
    $UserInput = Read-Host "FILE ALREADY EXISTS! Over-write file? (y/n)?"

    if ($UserInput -eq 'y') {
        $global:x = $testDir
        $global:startTheBackup = $true
    }
    else
    {
        Write-Host "Rerun script with a different backup directory"
        exit
    }
}

#Check drive freespace
$backupDriveLetter = (Get-Item $destDir).PSDrive.Name
$backupDeviceID = '"DeviceId=' + $backupDriveLetter + ":'" + '"'
$freespace = (Get-CimInstance CIM_LogicalDisk -Filter $backupDrive).FreeSpace

Write-Host $requiredspace " Required"
Write-Host $freespace " Available"

if ($freespace -gt  $requiredspacespace) {
	Write-Host "Sufficient space for backup, proceeding..."
}
else {
	#prompt user to exit script
     Write-Host "Not enough space on the selected drive:" $backupDriveLetter
     Write-Host "Please clear some space or use a different drive"
     exit
}

# Boolean globals to direct backup script
$global:shutdownComp = $false

<#
#kill process if conditions for starting aren't met
if (!$global:startTheBackup) {
    Write-Host "An error occured, try running the script again"
    Return
}
#>

#Make the folder named from $time, in directory from global:x
if ($debug) 
{
    New-Item -Path $destDir -Name $time -ItemType "directory" -Force
}
else 
{ 
    #no excess output for user
    [void](New-Item -Path $destDir -Name $time -ItemType "directory" -Force)
}

Write-Host $backupDir "created!"

Write-Host "For the backup to work properly, Dentrix, Dexis, and database processes must be shutdown"
Write-Host ""

#User decides if computer should shutdown after backup, also given a chance to cancel the backup
$UserInput = Read-Host "Do you want the computer to shutdown after it completes (y/n or c to cancel)?"
if ($UserInput -eq 'y') {
    $global:shutdownComp = $true
}
elseif ($UserInput -eq 'n')
{
    $global:shutdownComp = $false

}
else
{
    write-host "Backup canceled. If this in error, just run script again."
    Return
}

#Turn off processes using the Dentrix & Dexis databases
Close-Background-Processes

if ($global:startTheBackup) {
    #Dentrix
    try { 
        Copy-Item $global:Dentrix -Destination $global:x -Recurse -Force -errorAction stop
        Write-Host ".Dentrix folder copied..."
    }
    catch { 
        Write-Host ""
        Write-Host ".Dentrix backup failed!"
        Write-Host ""
        Write-Host "Backup failed - contact system administrator"
        Write-Host "Closing script"
        Return 
        }

    #Dexis
    try { 
        Copy-Item $global:Dexis -Destination $global:x -Recurse -Force -errorAction stop
        Write-Host ".Dexis folder copied..."
    }
    catch { 
        Write-Host ""
        Write-Host ".Dexis backup failed!"
        Write=Host ""
        Write-Host "Backup failed - contact system administrator"
        Write-Host "Closing script"
        Return 
    }

    Write-Host ""
	Write-Host "Backup Complete!"

    if ($debug)	{
        ## Get time for logging
	    Get-Date -UFormat "%c"
    }

	if ($global:shutdownComp) { #do we shut the computer down?
		Write-Host "Shutting down computer..."

		Stop-Computer # when backup is complete, shut down computer
	}
}

Write-Host "Script Completed!!!"
if ($debug) {
    Stop-Transcript ## Stop logging
}