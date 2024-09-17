. "$PSScriptRoot\2.ps1"

$loginLogoutResults = Get-LoginLogoutEvents -Days 14
$startupShutdownResults = Get-StartupShutdownEvents -Days 14

$combinedResults = $loginLogoutResults + $startupShutdownResults
$combinedResults = $combinedResults | Sort-Object Time

$combinedResults
