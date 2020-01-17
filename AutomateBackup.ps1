##Get Backup directory
function get-something {
    param(
          [Parameter(Mandatory=$true)]
          [string] $SaveDirectory
         )
        new-object psobject -property @{
            SaveDirectory=$savedirectory
        }
}
iex (show-command get-something -passthru)

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
#Copy-Item "C:\Dentrix" -Destination "X:\" -Recurse

## Make Dexis backup directory ##
$name = "dexis" + $time
New-Item -Path "c:\" -Name $name -ItemType "directory"

## Potentially automate cmds in Dexis and/or Dentrix ##
## Unmodified code for stack overflow ##
#$wshell = New-Object -ComObject wscript.shell;
#$wshell.AppActivate('title of the application window')
#Sleep 1
#$wshell.SendKeys('~')

#Copy-Item "" -Destination "" -Recurse

## When backup is complete, shut down computer ##
#Stop-Computer
