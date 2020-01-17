## Boolean to start/prevent backup script
$global:startTheBackup = $false

## Make GUI
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = 'Select Backup Directory'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Enter Backup Directory:"
$Label.Location  = New-Object System.Drawing.Point(0,10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Width = 300
$TextBox.Height = 30
$TextBox.Location  = New-Object System.Drawing.Point(0,30)
$main_form.Controls.Add($TextBox)

$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(30,50)
$Button.Size = New-Object System.Drawing.Size(120,30)
$Button.Text = "Ok"
$main_form.Controls.Add($Button)

$confirm_form = New-Object System.Windows.Forms.Form
$confirm_form.Text = 'Select Backup Directory'
$confirm_form.Width = 300
$confirm_form.Height = 300
$confirm_form.AutoSize = $true

$Lbl = New-Object System.Windows.Forms.Label
$Lbl.Text = "Backup Files to: "
$Lbl.Location  = New-Object System.Drawing.Point(0,10)
$Lbl.AutoSize = $true
$confirm_form.Controls.Add($Lbl)

$Lb2 = New-Object System.Windows.Forms.Label
$Lb2.Text = ""
$Lb2.Location  = New-Object System.Drawing.Point(0,30)
$Lb2.AutoSize = $true
$confirm_form.Controls.Add($Lb2)

$BtnYes = New-Object System.Windows.Forms.Button
$BtnYes.Location = New-Object System.Drawing.Size(0,50)
$BtnYes.Size = New-Object System.Drawing.Size(40,30)
$BtnYes.Text = "Yes"
$confirm_form.Controls.Add($BtnYes)

$BtnNo = New-Object System.Windows.Forms.Button
$BtnNo.Location = New-Object System.Drawing.Size(60,50)
$BtnNo.Size = New-Object System.Drawing.Size(70,30)
$BtnNo.Text = "Oops, No!"
$confirm_form.Controls.Add($BtnNo)

$Button.Add_Click(
{
	if (!$TextBox.Text -eq "") 
	{
		if (Test-Path $TextBox.Text -PathType Any) 
		{
			$global:x=$TextBox.Text
			$Lb2.Text = $global:x
			$confirm_form.ShowDialog()
		}
	}
}
)

$BtnYes.Add_Click(
{
	$global:startTheBackup = $true
	$main_form.Close()
	$confirm_form.Close()
	
}
)

$BtnNo.Add_Click(
{
	$confirm_form.Close()
}
)
	

$main_form.ShowDialog()

## Backup Operations - Boolean to prevent backup without GUI instructions
if ($global:startTheBackup)
{
## Make backup directory ##
$time = Get-Date -Format "MM.dd.yyyy"
Write-Host "Peforming backup to: " $global:x
New-Item -Path $global:x -Name $time -ItemType "directory" #throws null error for path

###    Backup Dentrix     ###
Write-Host "Launch Dentrix Backup Application..."
Write-Host "Automating Backup..."
Write-Host "Closing Dentrix Backup Application."
## Potentially automate cmds in Dexis and/or Dentrix ##
## Unmodified code for stack overflow ##
#$wshell = New-Object -ComObject wscript.shell;
#$wshell.AppActivate('title of the application window')
#Sleep 1
#$wshell.SendKeys('~')

## Perform Backup ##
Write-Host "Peforming the Dentrix Backup..."
#Copy-Item "C:\Dentrix" -Destination "X:\" -Recurse
Write-Host "Dentrix Backup Complete!"

###    Backup Dexis    ###
Write-Host "Launch Dexis Backup Application..."
Write-Host "Automating Backup..."
Write-Host "Closing Dexis Backup Application."
## Potentially automate cmds in Dexis and/or Dentrix ##
## Unmodified code for stack overflow ##
#$wshell = New-Object -ComObject wscript.shell;
#$wshell.AppActivate('title of the application window')
#Sleep 1
#$wshell.SendKeys('~')

## Perform Backup ##
Write-Host "Peforming the Dexis Backup..."
#Copy-Item "C:\Dexis" -Destination "X:\" -Recurse
Write-Host "Dexis Backup Complete!"

Wite-Host "Shutting down computer..."
## When backup is complete, shut down computer ##
#Stop-Computer

}
