# List all lines in access.log
# Get-Content C:\xampp\apache\logs\access.log

# List last 5 lines in access.log
# Get-Content C:\xampp\apache\logs\access.log -Tail 5

# Only logs that contain 404 or 400
# Get-Content C:\xampp\apache\logs\access.log | Where-Object {$_ -match '\b(404|400)\b'}

# Only logs that do not contain 200
# Get-Content C:\xampp\apache\logs\access.log | Where-Object {$_ -notmatch '\b(200)\b'}

# Get logs that contain the word 'error'
#Get-ChildItem -Filter *.log | Select-String -Pattern 'error' -CaseSensitive:$false | ForEach-Object {
  #  "$($_.FileName):$($_.LineNumber):$($_.Line)"
#}

# Get the IP addresses from lines containing 404
$ipList = @()

Get-Content C:\xampp\apache\logs\access.log | Select-String -Pattern '\b404\b' | ForEach-Object {
    if ($_ -match '\b(?:\d{1,3}\.){3}\d{1,3}\b') {
        $ipList += [PSCustomObject]@{
            "IP Address" = $matches[0]
        }
    }
}

$ipList | Format-Table

# Count the IPs
$ipList | Group-Object -Property 'IP Address' | Sort-Object Count -Descending | ForEach-Object {
    [PSCustomObject]@{
        "Count" = $_.Count
        "IP Address" = $_.Name
    }
}