<#Procedural Version	by Nicholas Zehm #>
## Directories to backup, set these variables
$global:dentrix = "C:\Dentrix"
$global:dexis = "C:\Dexis"
$debug = $true
if ($debug) {
	$logDirectory = "C:\NicksLog\AutoBackupProcedLog.txt"
}

## Boolean globals to direct backup script
$global:startTheBackup = $false
$global:shutdownComp = $false

## Directions in GUI
$txtText = "Step 1: Prepare Dentrix

A. Run _ServerAdmin

B: Select Export Backup Tab

C: Press Export Backup Button
-----------------------------------------------------------------
Step 2: Prepare Dexis

A: Press Lock button on top right

B: Run backup
-----------------------------------------------------------------
Step 3: Select whether to shut down computer after backup below


Shutdown computer after backup?"

## Make GUI
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'Select Backup Directory'
$main_form.Width = 400
$main_form.Height = 350
$main_form.AutoSize = $true

$txtBox1 = New-Object System.Windows.Forms.Label
$txtBox1.Text = $txtText
$txtBox1.Location  = New-Object System.Drawing.Point(0,10)
$txtBox1.AutoSize = $true
$main_form.Controls.Add($txtBox1)

$BtnYes = New-Object System.Windows.Forms.Button
$BtnYes.Location = New-Object System.Drawing.Size(10,250)
$BtnYes.Size = New-Object System.Drawing.Size(40,30)
$BtnYes.Text = "Yes"
$main_form.Controls.Add($BtnYes)

$BtnNo = New-Object System.Windows.Forms.Button
$BtnNo.Location = New-Object System.Drawing.Size(60,250)
$BtnNo.Size = New-Object System.Drawing.Size(40,30)
$BtnNo.Text = "No"
$main_form.Controls.Add($BtnNo)

$BtnCC = New-Object System.Windows.Forms.Button
$BtnCC.Location = New-Object System.Drawing.Size(110,250)
$BtnCC.Size = New-Object System.Drawing.Size(60,30)
$BtnCC.Text = "Cancel"
$main_form.Controls.Add($BtnCC)


$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog


$BtnYes.Add_Click(
{
	[void] $FolderBrowserDialog.ShowDialog()
	if (!$FolderBrowserDialog.SelectedPath -eq "") 
	{
		$time = Get-Date -Format "MM.dd.yyyy"
		$testDir = $FolderBrowserDialog.SelectedPath + '\' + $time
		$alreadyThere = Test-Path $testDir -PathType Any
		if (!$alreadyThere)
		{
			$main_form.Close()
			$global:startTheBackup = $true
			$global:shutdownComp = $true
			$global:x = $FolderBrowserDialog.SelectedPath
		}
		else
		{
			$Return=[System.Windows.Forms.MessageBox]::Show('Click OK to overwrite, or Cancel','Folder Already Exists!','okcancel')
			if ($Return -eq 'OK')
			{
				$global:overwriteFolder = $true
				$main_form.Close()
				$global:startTheBackup = $true
				$global:shutdownComp = $true
				$global:x = $FolderBrowserDialog.SelectedPath
			}
		}
	}
}
)

$BtnNo.Add_Click(
{
	[void] $FolderBrowserDialog.ShowDialog()
	if (!$FolderBrowserDialog.SelectedPath -eq "") 
	{
		$time = Get-Date -Format "MM.dd.yyyy"
		$testDir = $FolderBrowserDialog.SelectedPath + '\' + $time
		$alreadyThere = Test-Path $testDir -PathType Any
		if (!$alreadyThere)
		{
			$main_form.Close()
			$global:startTheBackup = $true
			$global:shutdownComp = $false
			$global:x = $FolderBrowserDialog.SelectedPath
		}
		else
		{
			$Return=[System.Windows.Forms.MessageBox]::Show('Click OK to overwrite, or Cancel','Folder Already Exists!','okcancel')
			if ($Return -eq 'OK')
			{
				$global:overwriteFolder = $true
				$main_form.Close()
				$global:startTheBackup = $true
				$global:shutdownComp = $false
				$global:x = $FolderBrowserDialog.SelectedPath
			}
		}
	}
}
)
$BtnCC.Add_Click(
{
	$main_form.Close()
}
)
if ($debug) {
	Start-Transcript -path $logDirectory -appen ##Adjust for usage machine
}

$main_form.ShowDialog()

## Backup Operations - Boolean to prevent backup without GUI instructions
if ($global:startTheBackup)
{
	## Peforms backup directory - Overwrite files applicable to gui selection##
	$time = Get-Date -Format "MM.dd.yyyy"
	Write-Host "Peforming backup at: " $global:x
	New-Item -Path $global:x -Name $time -ItemType "directory" -Force
	$backupDir = $global:x + '/' + $time
		
	## Perform Dentrix Backup ##
	Write-Host "Performing the Dentrix Backup..."
	Copy-Item "C:\Dentrix" -Destination $backupDir -Recurse -Force
	Write-Host "Dentrix Backup Complete!"
	
	## Get time for logging
	Get-Date -UFormat "%c"

	## Perform Dexis Backup ##
	Write-Host "Performing the Dexis Backup..."
	Copy-Item "C:\Dexis" -Destination $backupDir -Recurse -Force
	Write-Host "Dexis Backup Complete!"
	
	## Get time for logging
	Get-Date -UFormat "%c"

	if ($global:shutdownComp) #do we shut the computer down
	{
		Write-Host "Shutting down computer..."
		## When backup is complete, shut down computer ##
		Stop-Computer
	}
}
