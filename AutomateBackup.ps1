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


## try to pause the program to put the input into $savedirectory, must be doing something wrong
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');


## Make backup directory ##
$time = Get-Date -Format "MM.dd.yyyy"
New-Item -Path $savedirectory -Name $time -ItemType "directory" #throws null error for path


###    Backup Dentrix     ###
## Potentially automate cmds in Dexis and/or Dentrix ##
## Unmodified code for stack overflow ##
#$wshell = New-Object -ComObject wscript.shell;
#$wshell.AppActivate('title of the application window')
#Sleep 1
#$wshell.SendKeys('~')

## Perform Backup ##
#Copy-Item "C:\Dentrix" -Destination "X:\" -Recurse


###    Backup Dexis    ###
## Potentially automate cmds in Dexis and/or Dentrix ##
## Unmodified code for stack overflow ##
#$wshell = New-Object -ComObject wscript.shell;
#$wshell.AppActivate('title of the application window')
#Sleep 1
#$wshell.SendKeys('~')

## Perform Backup ##
#Copy-Item "C:\Dexis" -Destination "X:\" -Recurse

## When backup is complete, shut down computer ##
#Stop-Computer
