#New-ScheduledTask

#? Start-ScheduledTask
#? Stop-ScheduledTask
#? Wait-Event

#Make Dentrix backup directory
$time = Get-Date -Format "MM.dd.yyyy"
$name = "dentrix" + $time
New-Item -Path "c:\" -Name $name -ItemType "directory"

#Copy-Item

#Make Dexis backup directory
$name = "dexis" + $time
New-Item -Path "c:\" -Name $name -ItemType "directory"

#Copy-Item

#Stop-Computer

#
$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate('title of the application window')
Sleep 1
$wshell.SendKeys('~')
#
