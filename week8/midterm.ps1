# Challenge 1
# getIocs | Format-Table

# Challenge 2
# getLogs "$PSScriptRoot\access.log" | Format-Table

# Challenge 3
getSuspicious -Path "$PSScriptRoot\access.log" | Format-Table

function getIocs() 
{
    $page = Invoke-WebRequest -TimeoutSec 2 http://127.0.0.1/IOC.html

    # Get all the tr elements of HTML document
    $trs = $page.ParsedHtml.body.getElementsByTagName("tr")

    # Empty array to hold results
    $FullTable = @()
    
    for ($i = 1; $i -lt $trs.length; $i++) { # Going over every tr element
        # Get every td element of current tr element
        $tds = $trs[$i].getElementsByTagName("td")

        $FullTable += [PSCustomObject]@{
            "Pattern" = $tds[0].innerText;
            "Description"      = $tds[1].innerText;
        }
    }
    return $FullTable
}

function getLogs()
{
    param (
        [string]$Path  # The folder containing Apache log files
    )

    $parsedLogs = @()  # Initialize an empty array to store parsed log objects

    # Regular expression to match IP address
    $ipRegex = '\b(?:\d{1,3}\.){3}\d{1,3}\b'

    # Read each line of the log file
    Get-Content $Path | ForEach-Object {
        $logLine = $_

        # Split the log line by spaces
        $logWords = $logLine -split ' '

        # Check if we have enough elements in the log line (to avoid errors)
        if ($logWords.Length -ge 10 -and $logWords[0] -match $ipRegex) {
            # Create a custom object from the log
            $logObject = [PSCustomObject]@{
                "IP"            = $logWords[0]
                "Identity"      = $logWords[1]
                "User"          = $logWords[2]
                "Timestamp"     = $logWords[3] + " " + $logWords[4]  # Timestamp is often split across two indices
                "RequestMethod" = ($logWords[5] -replace '"', '')  # Remove double quotes
                "URL"           = $logWords[6]
                "Protocol"      = ($logWords[7] -replace '"', '')  # Remove double quotes
                "HTTPStatus"    = $logWords[8]
                "BytesSent"     = $logWords[9]
                "Referrer"      = ($logWords[10] -replace '"', '')  # Remove double quotes
                "UserAgent"     = [string]::Join(' ', $logWords[11..($logWords.Length-1)])  # Join remaining parts for UserAgent
            }

            # Filter for IPs in the 10.* network
            if ($logObject.IP -like "10.*") {
                $parsedLogs += $logObject  # Add to the array if IP matches the 10.* network
            }
          }
        
      }

    return $parsedLogs  # Return the array of parsed log objects
}

function getSuspicious() {
    param (
        [string]$Path
    )

    # Get the parsed IOCs
    $iocs = getIocs

    # Get the parsed logs
    $logs = getLogs -Path $Path

    $susList = @()

    
    foreach ($log in $logs) {
        foreach ($ioc in $iocs) {
            if ($log.URL -like "*$($ioc.Pattern)*") {
                $susList += $log 
                break 
            }
        }
    }

    return $susList
}