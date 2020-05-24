# Backup-Powershell
Automate and configure file backups with powershell

Backup-Powershell is a batch script and a powershell script that automates backups of Dentrix and Dexis software, then shuts down the computer.
It provides the opportunity to overwrite preexisting backups if they exist, and the option to not shutdown the computer

The script is activated by the user clicking/launching the batch file
> AutomateBackup.bat

This launches the powershell script without requiring changes to powershell script run permissions. The script provides the user with a windows form GUI for directing the backup location. The Dentrix and Dexis are backed up to the user selected directory.

### To Install (if needed)
Simply place both scripts in the same directory.

### Development ###
* Cannot copy an essential file from the dexis directory. This is either becuase the file is locked as it is in use, or mirely a user escalation is required. This issue need to to be fixed.
* Some processes may still prevent windows from properly shutting down. These processes need to be noted so they can be scripted to shut down.



### Future Updates
Clean up labels in gui for clear instructions.









