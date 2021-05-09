# Backup-Powershell
Automate and configure file backups with powershell

***
5/9/21 NOTE: This version doesn't work well with dexis backup. Because dexis backup is fairly fast, I may forgo automating the dexis backup and only do dentrix. Because this software is geared for the software at my workplace, the new version will also include directions for the new backup protocol.
***

Backup-Powershell is a batch script and a powershell script that automates backups of Dentrix and Dexis software, then shuts down the computer. It provides the opportunity to overwrite preexisting backups if they exist, and the option to not shutdown the computer

The script is activated by the user clicking/launching the batch file
> AutomateBackup.bat (see How To Use before running)

This launches the powershell script without requiring changes to powershell script run permissions. The script provides the user with a windows form GUI for directing the backup location. The Dentrix and Dexis are backed up to the user selected directory.

### Parallel versus Procedural
There are two versions in this repository
this (master) = Procedural
  This conducts each backup 1 at a time. Advantage: Minimal fragmentation (if applicable). Cons: Slower (testing in progress).

Parallel
  This conducts both backups at the same time. Advantage: Probably faster. Cons: Possible fragmentation of backup on drive.

I will be testing both methods. If parallel is faster, I will use this as a primary, as fragmentation of backups is not a concern.

### To Install (if needed)
Simply place both scripts in the same directory.

### HOW TO USE
1. Edit the automateBackup.ps1 script to set the $dexis and $dentrix directories to the directories to backup. If using debug mode, set the log directory.
***Note:
The current edition works best using the backup directories of both programs. Both Dexis and Dentrix programs have their own backup tool. Run those first, then use this to automate the backup.  Attempting to backup both database directories directly fails to properly backup dexis. Presumbly dexis continues to maintain read/write control of its database file preventing this script from copying it. 

2. The script is activated by the user clicking/launching the batch file
> AutomateBackup.bat

3. The GUI will launch with recommended steps for preparing the backup. I recommend following those as mentioned in the note above. 

4. Select whether to shutdown the computer after backup (or cancel to close script)

5. Select backup directory
  The program will prompt if a backup exists in the directory with the same date stamp (see script for details)

6. The bat console with update with the status of the script. Note any errors, when completed hit enter as prompted, or close the console.

### Development
There is now a parallel backup version and a procedural backup verion. Both have logging on for now to examine time efficency of parallel. Parallel is 'unstable' at least until I get around to testing it.

### Future Updates
* Cannot copy an essential file from the dexis directory. This is either becuase the file is locked as it is in use, or mirely a user escalation is required. This issue will need to to be fixed for a particular use case. Not applicable if backup is made soley from Dexis backup export (Which I will now recommend for users, involves extra steps but may be faster)
* Clean up labels in gui for clear instructions.
* Update code with changes generated in client version of code.
