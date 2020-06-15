$dentrix=""

## Perform Dentrix Backup ##
Write-Host "Performing the Dentrix Backup..."
Copy-Item $dentrix -Destination $backupDir -Recurse -Force
Write-Host "Dentrix Backup Complete!"
