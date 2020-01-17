@ECHO OFF
REM Goto ps1 directory

REM launch powershell, bypass security policy
PowerShell.exe -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"

REM If admin is needed:
REM PowerShell.exe -Command "& {Start-Process PowerShell.exe -ArgumentList '-ExecutionPolicy Bypass -File ""%~dpn0.ps1""' -Verb RunAs}"
PAUSE
