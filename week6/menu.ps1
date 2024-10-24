. "$PSScriptRoot\..\week4\parse_apache.ps1"
. "$PSScriptRoot\..\week6\Users.ps1"
. "$PSScriptRoot\..\week6\Event-Logs.ps1"

$Prompt = "`nSelect an option:`n"
$Prompt += "1 - Display last 10 apache logs`n"
$Prompt += "2 - Display last 10 failed logins for all users`n"
$Prompt += "3 - Display at risk users`n"
$Prompt += "4 - Start Chrome web browser and go to champlain.edu`n"
$Prompt += "5 - Exit`n"

while($true)
{
    Write-Host $Prompt
    $choice = Read-Host

    switch($choice)
    {
        1 { ParseLogs -Path 'C:\xampp\apache\logs\access.log' | Select -Last 10 | Format-Table }
        2 { getFailedLogins 90 | Select Time, User -Last 10 | Format-Table }
        3 {
            getFailedLogins 90 | Group-Object -Property User | Where-Object {$_.Count -gt 10} | Select-Object Name, Count | Format-Table
          }
        4 { & "$PSScriptRoot\..\week2\openweb.ps1" }
        5 { Write-Output "`nGoodbye!`n"; return }

        Default 
          { Write-Host "Invalid selection" }
        
    }
}
