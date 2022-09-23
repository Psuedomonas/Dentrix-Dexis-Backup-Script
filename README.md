# Automate Backup

## Files
    AutomateBackup.ps1 - script
    AutomateBackup.bat - batch launcher

## Purpose
    Backup Dentrix and Dexis databases for system recovery and data security
    
These scripts use so called 'dumb' backups, as these are simple and safest for our situation. 'Dumb' refers to a whole backup, verses a 'Smart' backup of changes. This is the final version that supports the use of built in backup features of De

## Usage:

    Check script to ensure backup directories are correct
    If powershell execution policy does not enable remote unsigned scripts, use the AutomateBackup.bat to lauch script. (You may be able to add a local signature if you wish).
    Follow the prompts the script provides

Cheers 

Nicholas Zehm
