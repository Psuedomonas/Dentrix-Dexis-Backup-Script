# Automate Backup

## Essential Files
  AutomateBackupFull.ps1 - script
  AutomateBackupFull.bat - batch launcher

## Purpose
    Backup Dentrix and Dexis databases for system recovery and data security
    
These scripts use so called 'dumb' backups, as these are simple and safest for our situation. 'Dumb' refers to a whole backup, verses a 'Smart' backup of changes.
This particular script copies the full directories of both Dexis and Dentrix as this seems to correlate to best recovery.
Version 2.4 will remain the version for using Dentrix and Dexis backup features. However, 2.4 will not be maintained. Furthermore 2.5 will likely be the last version for the scripts intended purpose.

## Usage:

1. Check script to ensure backup directories are correct

2. If powershell execution policy does not enable remote unsigned scripts, use the AutomateBackup.bat to lauch script. (You may be able to add a local signature if you wish).

3. Follow the prompts the script provides

Cheers

Nicholas Zehm
