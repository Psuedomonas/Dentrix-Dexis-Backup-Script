@ECHO OFF

REM launch powershell, bypass security policy, run script with same name as batch file
PowerShell.exe -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"

PAUSE
