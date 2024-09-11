# Get all stopped services
$stoppedServices = Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Sort-Object Name

# Save the result to a CSV file
$stoppedServices | Select-Object Name, DisplayName, Status | Export-Csv -Path "$PSScriptRoot\stopped_services.csv" -NoTypeInformation
