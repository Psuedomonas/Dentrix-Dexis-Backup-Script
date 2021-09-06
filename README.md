## AutomateBackup.ps1
#### Automate Dentrix (and vicariously Dexis) backup with powershell
#### For Powershell version 5.1
#### Nicholas Zehm

This is a console interface script that provides step by step instructions to backup Dexis, and automate a backup of Dentrix. The backup method for Dentrix is probably wasteful in the amount of files it copies, but it should ensure recovery.

The version 1.x utilized a crude windows forms interface, but I found it to be unnecessarily time consuming trying to sort out the GUI. The use case for this script, especially with the guide output, is exceptionally narrow, so I assume this script would be best used as a guide to develop other backup scripts rather than to be used exactly as is and as intended.

### Version 2.1 (8/30/21)
#### Changes: 
	Added a check for sufficient disk size for backup
	Code clean-up
	Internal script name change

### Verson 2 (5/9/21)
#### Changes: 
	Rewrite for console interface
	Optimized protocol to minimize time, excess storage (Unfortatetly, it requires some focus by the user to utilize correctly)

