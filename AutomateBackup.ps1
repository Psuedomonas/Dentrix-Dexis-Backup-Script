## 
## May not use, may make an .exe or something the user clicks on instead
#New-ScheduledTask
#? Start-ScheduledTask
#? Stop-ScheduledTask
#? Wait-Event
##

## Make Dentrix backup directory ##
$time = Get-Date -Format "MM.dd.yyyy"
$name = "dentrix" + $time
New-Item -Path "c:\" -Name $name -ItemType "directory"

## Potentially automate cmds in Dexis and/or Dentrix ##
## Unmodified code for stack overflow ##
#$wshell = New-Object -ComObject wscript.shell;
#$wshell.AppActivate('title of the application window')
#Sleep 1
#$wshell.SendKeys('~')

## Perform Backup ##
#Copy-Item

## Make Dexis backup directory ##
$name = "dexis" + $time
New-Item -Path "c:\" -Name $name -ItemType "directory"

## Potentially automate cmds in Dexis and/or Dentrix ##
## Unmodified code for stack overflow ##
#$wshell = New-Object -ComObject wscript.shell;
#$wshell.AppActivate('title of the application window')
#Sleep 1
#$wshell.SendKeys('~')

#Copy-Item

## When backup is complete, shut down computer ##
#Stop-Computer
