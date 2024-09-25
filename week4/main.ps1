. $PSScriptRoot\Apache-Logs.ps1

$ipList = Get-FilteredIPs -PageVisited 'page1.html'-HttpCode '200' -Browser 'Chrome'

$ipList | Group-Object -Property 'IP Address' | Sort-Object Count -Descending | ForEach-Object {
    [PSCustomObject]@{
        "Count" = $_.Count
        "IP Address" = $_.Name
    }
}